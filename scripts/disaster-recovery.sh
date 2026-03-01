#!/bin/bash
# 🛡️ 容灾恢复脚本 (Disaster Recovery)
# 用途：检测故障、自动切换、通知用户

set -e

# ==================== 配置 ====================

SCRIPT_NAME="disaster-recovery"
LOG_FILE="/tmp/disaster-recovery.log"
STATE_FILE="/tmp/dr-state.json"
NOTIFY_FILE="/tmp/notify/dr-alert.txt"

# 服务器列表
PRIMARY_HOST="localhost"          # 龙虾 (本机)
BACKUP_HOST="117.72.119.78"       # 布鲁斯 (远程)
SSH_USER="ubuntu"

# GitHub 仓库 (状态同步)
STATUS_REPO="hangyuwei/OpenClaw"
STATUS_FILE="dr-status.json"

# 通知渠道
TELEGRAM_USER_ID="6388265865"

# 检查阈值
MAX_PING_MS=1000
MAX_RETRY=3
CHECK_INTERVAL=60  # 秒

# ==================== 日志函数 ====================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ ERROR: $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ OK: $1" | tee -a "$LOG_FILE"
}

# ==================== 健康检查 ====================

check_local_gateway() {
    # 检查本地 Gateway 状态 (检查进程是否存在)
    if pgrep -f "openclaw-gateway" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_remote_host() {
    # 检查远程主机连通性
    local host=$1
    if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_remote_gateway() {
    # 通过 SSH 检查远程主机 (仅 ping + SSH 端口)
    # 注意：需要先配置 SSH 免密登录
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no \
        "${SSH_USER}@${BACKUP_HOST}" "echo ok" >/dev/null 2>&1; then
        return 0
    else
        # SSH 未配置时，仅检查端口
        nc -z -w 2 "$BACKUP_HOST" 22 >/dev/null 2>&1
        return $?
    fi
}

check_internet() {
    # 检查外网连接
    if curl -s --max-time 5 https://www.baidu.com >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_github() {
    # 检查 GitHub 连接
    if ssh -T git@github.com -o ConnectTimeout=5 >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# ==================== 状态同步 ====================

update_status() {
    local status=$1
    local host=$2
    local timestamp=$(date -Iseconds)
    
    # 更新本地状态文件
    cat > "$STATE_FILE" << EOF
{
    "status": "$status",
    "host": "$host",
    "timestamp": "$timestamp",
    "primary": {
        "host": "$PRIMARY_HOST",
        "online": $([ "$status" = "primary-active" ] && echo "true" || echo "false")
    },
    "backup": {
        "host": "$BACKUP_HOST",
        "online": $([ "$status" = "backup-active" ] && echo "true" || echo "false")
    }
}
EOF
    
    log "状态已更新：$status @ $host"
}

sync_to_github() {
    # 同步状态到 GitHub (作为持久化备份)
    if [ -f "$STATE_FILE" ]; then
        cd ~/.openclaw/workspace
        cp "$STATE_FILE" "$STATUS_FILE" 2>/dev/null || true
        git add "$STATUS_FILE" 2>/dev/null || true
        git commit -m "dr: 状态同步 $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || true
        git push origin main 2>/dev/null || log_error "GitHub 同步失败"
    fi
}

# ==================== 通知机制 ====================

send_notification() {
    local title=$1
    local message=$2
    local level=$3  # info/warn/critical
    
    # 创建通知文件 (由 heartbeat 读取发送)
    mkdir -p "$(dirname "$NOTIFY_FILE")"
    
    cat > "$NOTIFY_FILE" << EOF
🛡️ 容灾告警 - $title

级别：$level

$message

时间：$(date '+%Y-%m-%d %H:%M:%S')
主机：$(hostname)
EOF
    
    log "通知已创建：$title"
}

# ==================== 故障切换 ====================

failover_to_backup() {
    log "开始故障切换：Primary → Backup"
    
    # 1. 通知用户
    send_notification "故障切换" "主服务器 ($PRIMARY_HOST) 不可用，已切换到备份服务器 ($BACKUP_HOST)" "critical"
    
    # 2. 更新状态
    update_status "backup-active" "$BACKUP_HOST"
    
    # 3. 同步到 GitHub
    sync_to_github
    
    # 4. 记录切换日志
    log "故障切换完成"
}

failback_to_primary() {
    log "开始故障回切：Backup → Primary"
    
    # 1. 通知用户
    send_notification "故障回切" "主服务器 ($PRIMARY_HOST) 已恢复，切换回主服务器" "info"
    
    # 2. 更新状态
    update_status "primary-active" "$PRIMARY_HOST"
    
    # 3. 同步到 GitHub
    sync_to_github
    
    # 4. 记录回切日志
    log "故障回切完成"
}

# ==================== 主循环 ====================

run_check_cycle() {
    local primary_ok=true
    local backup_ok=false
    local issues=""
    
    # 检查主服务器 (宽松检查)
    if ! pgrep -f "openclaw-gateway" >/dev/null 2>&1; then
        primary_ok=false
        issues="$issues Gateway 离线;"
    fi
    
    if ! curl -s --max-time 5 https://www.baidu.com >/dev/null 2>&1; then
        issues="$issues 外网异常;"
    fi
    
    if $primary_ok; then
        log_success "主服务器健康"
    else
        log_error "主服务器异常:$issues"
    fi
    
    # 检查备份服务器 (仅 ping 检查)
    if ping -c 1 -W 2 "$BACKUP_HOST" >/dev/null 2>&1; then
        backup_ok=true
        log_success "备份服务器在线"
    else
        log_error "备份服务器离线"
    fi
    
    # 决策
    if $primary_ok; then
        # 主服务器正常
        local last_status=$(jq -r '.status' "$STATE_FILE" 2>/dev/null || echo "")
        if [ "$last_status" = "backup-active" ]; then
            failback_to_primary
        fi
    elif $backup_ok; then
        # 主服务器故障，备份可用
        failover_to_backup
    else
        # 双机故障 (仅当主服务器确实故障时才告警)
        if [ "$primary_ok" = "false" ]; then
            send_notification "主服务器故障" "主服务器异常:$issues 备份服务器：$([ "$backup_ok" = "true" ] && echo "在线" || echo "离线")" "critical"
            log_error "主服务器故障！"
        fi
    fi
}

# ==================== 入口 ====================

main() {
    local mode="${1:-daemon}"
    
    log "=========================================="
    log "容灾恢复系统启动"
    log "模式：$mode"
    log "主服务器：$PRIMARY_HOST"
    log "备份服务器：$BACKUP_HOST"
    log "=========================================="
    
    case "$mode" in
        daemon)
            # 守护模式：持续监控
            log "进入守护模式，每 ${CHECK_INTERVAL}秒检查一次"
            while true; do
                run_check_cycle
                sleep "$CHECK_INTERVAL"
            done
            ;;
        
        check)
            # 单次检查
            run_check_cycle
            ;;
        
        status)
            # 显示状态
            if [ -f "$STATE_FILE" ]; then
                cat "$STATE_FILE" | jq .
            else
                echo "无状态文件"
            fi
            ;;
        
        test)
            # 测试通知
            send_notification "测试" "这是一条测试通知" "info"
            echo "测试通知已创建：$NOTIFY_FILE"
            ;;
        
        *)
            echo "用法：$0 {daemon|check|status|test}"
            exit 1
            ;;
    esac
}

main "$@"
