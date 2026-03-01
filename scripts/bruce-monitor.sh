#!/bin/bash
# 布鲁斯服务器监控脚本
# SSH 登录检查 OpenClaw 状态和日志

LOG_FILE="/tmp/bruce-monitor.log"
NOTIFY_FILE="/tmp/notify/bruce-monitor.txt"
BRUCE_IP="117.72.119.78"
BRUCE_PASSWORD="Hyw@19980224"
CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# 记录日志
log() {
    echo "[$CURRENT_TIME] $1" >> "$LOG_FILE"
}

log "开始检查布鲁斯服务器..."

# SSH 登录检查
CHECK_RESULT=$(sshpass -p "$BRUCE_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 root@$BRUCE_IP << 'EOF' 2>&1
echo "=== 系统负载 ==="
uptime

echo -e "\n=== 内存使用 ==="
free -h

echo -e "\n=== OpenClaw 进程 ==="
ps aux | grep -E 'openclaw|node.*agent' | grep -v grep

echo -e "\n=== OpenClaw 服务状态 ==="
systemctl status openclaw 2>&1 | head -15

echo -e "\n=== 最近错误日志 ==="
journalctl -u openclaw --since "10 minutes ago" --no-pager --priority=err | tail -20

echo -e "\n=== Gateway 进程 ==="
ps aux | grep -i 'openclaw.*gateway' | grep -v grep

echo -e "\n=== CPU 使用 TOP5 ==="
ps aux --sort=-%cpu | head -6
EOF
)

# 保存完整检查结果
echo "$CHECK_RESULT" > "/tmp/bruce-check-result-$(date +%Y%m%d%H%M%S).txt"

log "SSH 检查完成"

# 分析检查结果
ISSUES=0
ISSUE_DETAILS=""

# 检查 1: 负载过高 (>5)
if echo "$CHECK_RESULT" | grep -qE "load average.*[5-9]\.[0-9]|load average.*[1-9][0-9]\."; then
    ISSUES=$((ISSUES + 1))
    ISSUE_DETAILS="${ISSUE_DETAILS}⚠️ 系统负载过高\n"
    log "检测到高负载"
fi

# 检查 2: 可用内存不足 (<1GB)
AVAILABLE_MEM=$(echo "$CHECK_RESULT" | grep "Mem:" | awk '{print $7}')
if [ -n "$AVAILABLE_MEM" ]; then
    # 转换为MB（如 14Gi -> 14*1024 = 14336MB）
    if echo "$AVAILABLE_MEM" | grep -q "Gi"; then
        MEM_MB=$(echo "$AVAILABLE_MEM" | sed 's/Gi//' | awk '{print int($1*1024)}')
    elif echo "$AVAILABLE_MEM" | grep -q "Mi"; then
        MEM_MB=$(echo "$AVAILABLE_MEM" | sed 's/Mi//' | awk '{print int($1)}')
    else
        MEM_MB=9999
    fi

    if [ "$MEM_MB" -lt 1024 ]; then
        ISSUES=$((ISSUES + 1))
        ISSUE_DETAILS="${ISSUE_DETAILS}⚠️ 可用内存不足 1GB\n"
        log "检测到内存不足"
    fi
fi

# 检查 3: OpenClaw 进程不存在
if ! echo "$CHECK_RESULT" | grep -q "openclaw-gateway"; then
    ISSUES=$((ISSUES + 1))
    ISSUE_DETAILS="${ISSUE_DETAILS}🚨 OpenClaw Gateway 进程未运行\n"
    log "检测到 OpenClaw Gateway 进程未运行"
fi

# 检查 4: 服务异常
if echo "$CHECK_RESULT" | grep -q "failed\|inactive\|dead"; then
    ISSUES=$((ISSUES + 1))
    ISSUE_DETAILS="${ISSUE_DETAILS}⚠️ OpenClaw 服务状态异常\n"
    log "检测到服务异常"
fi

# 如果有问题，创建通知
if [ $ISSUES -gt 0 ]; then
    log "发现 $ISSUES 个问题，创建通知"

    cat > "$NOTIFY_FILE" << EOF
布鲁斯服务器监控报告 🦞

检测到 $ISSUES 个问题：

$ISSUE_DETAILS

详细检查结果：
$CHECK_RESULT

请及时处理，必要时重启 OpenClaw 服务。
EOF

    log "通知已写入: $NOTIFY_FILE"
else
    log "✅ 布鲁斯状态正常"
fi

log "检查完成"
