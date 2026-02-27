#!/bin/bash
# 系统健康检查（每小时执行）
# 自动发现并修复问题

LOG_FILE="/tmp/health-check.log"
OBSIDIAN_DIR="/home/ubuntu/.openclaw/workspace/obsidian-vault"

echo "========================================" >> "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始健康检查" >> "$LOG_FILE"

# 1. 检查服务端口
check_port() {
    local PORT=$1
    local SERVICE_NAME=$2

    if netstat -tlnp 2>/dev/null | grep -q ":$PORT "; then
        echo "[✓] $SERVICE_NAME (端口 $PORT) 正常" >> "$LOG_FILE"
        return 0
    else
        echo "[✗] $SERVICE_NAME (端口 $PORT) 未运行！" >> "$LOG_FILE"
        return 1
    fi
}

# 2. 自动修复服务
fix_service() {
    local PORT=$1
    local SERVICE_NAME=$2

    echo "[修复] 尝试启动 $SERVICE_NAME..." >> "$LOG_FILE"

    case $PORT in
        5173)
            cd /home/ubuntu/health-assessment
            nohup npm run dev:h5 > /tmp/health-h5.log 2>&1 &
            ;;
        3001|3002)
            cd /home/ubuntu/health-assessment/admin
            nohup npm run dev > /tmp/health-admin.log 2>&1 &
            ;;
        18789)
            systemctl --user restart openclaw-gateway
            sleep 3
            ;;
    esac

    sleep 5

    # 验证是否成功
    if netstat -tlnp 2>/dev/null | grep -q ":$PORT "; then
        echo "[✓] $SERVICE_NAME 修复成功" >> "$LOG_FILE"
        return 0
    else
        echo "[✗] $SERVICE_NAME 修复失败" >> "$LOG_FILE"
        return 1
    fi
}

# 3. 记录到 Obsidian
log_to_obsidian() {
    local MESSAGE=$1
    local LOG_FILE="$OBSIDIAN_DIR/工作流程/自动修复记录.md"

    # 确保文件存在
    mkdir -p "$OBSIDIAN_DIR/工作流程"
    if [ ! -f "$LOG_FILE" ]; then
        echo "# 自动修复记录

> 龙虾自动发现并修复的问题

" > "$LOG_FILE"
    fi

    echo "- **$(date '+%Y-%m-%d %H:%M:%S')** - $MESSAGE" >> "$LOG_FILE"
}

# 检查所有服务
SERVICES=(
    "5173:H5患者端"
    "3001:Admin前台"
    "3002:Admin API"
    "18789:Gateway"
)

ISSUES_FOUND=0

for SERVICE in "${SERVICES[@]}"; do
    PORT=$(echo "$SERVICE" | cut -d: -f1)
    NAME=$(echo "$SERVICE" | cut -d: -f2)

    if ! check_port "$PORT" "$NAME"; then
        ISSUES_FOUND=$((ISSUES_FOUND + 1))

        if fix_service "$PORT" "$NAME"; then
            log_to_obsidian "自动修复 **$NAME** (端口 $PORT) - 服务宕机，已重启 ✅"
        else
            log_to_obsidian "修复失败 **$NAME** (端口 $PORT) - 需要人工介入 ❌"
        fi
    fi
done

# 4. 检查磁盘空间
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "[⚠] 磁盘使用率: $DISK_USAGE%" >> "$LOG_FILE"
    log_to_obsidian "磁盘空间警告 - 使用率 ${DISK_USAGE}%"

    # 自动清理
    if [ "$DISK_USAGE" -gt 90 ]; then
        echo "[清理] 清理日志文件..." >> "$LOG_FILE"
        find /tmp -name "*.log" -mtime +7 -delete 2>/dev/null
        find ~/.npm/_logs -name "*.log" -mtime +7 -delete 2>/dev/null
    fi
fi

# 5. 检查 Gateway 状态
if ! systemctl --user is-active openclaw-gateway &>/dev/null; then
    echo "[✗] Gateway 服务未运行" >> "$LOG_FILE"
    systemctl --user restart openclaw-gateway
    log_to_obsidian "Gateway 服务宕机，已重启"
fi

# 6. 检查 Node 服务
if ! systemctl --user is-active openclaw-node &>/dev/null; then
    echo "[✗] Node 服务未运行" >> "$LOG_FILE"
    systemctl --user restart openclaw-node
    log_to_obsidian "Node 服务宕机，已重启"
fi

# 总结
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 健康检查完成，发现 $ISSUES_FOUND 个问题" >> "$LOG_FILE"

# 如果有问题，同步到 Obsidian
if [ "$ISSUES_FOUND" -gt 0 ]; then
    cd "$OBSIDIAN_DIR"
    git add -A
    git commit -m "🤖 自动修复: 发现并修复 $ISSUES_FOUND 个问题" 2>/dev/null
    git push 2>/dev/null
fi
