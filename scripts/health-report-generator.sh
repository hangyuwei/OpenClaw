#!/bin/bash
# 健康报告生成器 - 生成系统健康报告并通知用户

LOG_DIR="/tmp"
NOTIFY_DIR="/tmp/notify"
REPORT_FILE="$LOG_DIR/health-report-daily.md"

# 确保通知目录存在
mkdir -p $NOTIFY_DIR

# 获取系统信息
MEMORY_USED=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2}')
MEMORY_GB=$(free -m | awk 'NR==2{printf "%.1f/%.1fGB", $3/1024, $2/1024}')
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
DISK_USED=$(df -h / | awk 'NR==2{printf "%s", $5}')
DISK_GB=$(df -h / | awk 'NR==2{printf "%s/%s", $3, $2}')
DISK_NUM=$(df -h / | awk 'NR==2{gsub(/%/,""); print $5}')

# 获取进程数
PROCESS_COUNT=$(ps aux | wc -l)

# 获取 OpenClaw 状态
GATEWAY_STATUS=$(systemctl --user is-active openclaw-gateway.service 2>/dev/null || echo "unknown")
NODE_STATUS=$(systemctl --user is-active openclaw-node.service 2>/dev/null || echo "unknown")

# 获取 Git 状态
cd /home/ubuntu/.openclaw/workspace
GIT_STATUS=$(git status --porcelain 2>/dev/null | wc -l)

# 状态判断函数
check_status() {
    if [ "$1" -lt "$2" ]; then
        echo "🟢"
    else
        echo "🟡"
    fi
}

MEMORY_STATUS=$(check_status $MEMORY_USED 70)
DISK_STATUS=$(check_status $DISK_NUM 80)

# 生成通知摘要
if [ "$GATEWAY_STATUS" = "active" ] && [ "$NODE_STATUS" = "active" ] && [ $MEMORY_USED -lt 80 ] && [ $DISK_NUM -lt 90 ]; then
    SUMMARY="✅ 系统运行正常"
else
    SUMMARY="⚠️ 部分服务异常，请查看完整报告"
fi

# 生成通知文件
cat > $NOTIFY_DIR/health-report.txt << EOF
🦞 龙虾健康报告

📊 系统状态：
- 内存：${MEMORY_USED}% (${MEMORY_GB})
- 负载：$LOAD_AVG
- 磁盘：${DISK_USED} (${DISK_GB})
- OpenClaw: Gateway=$GATEWAY_STATUS, Node=$NODE_STATUS

$SUMMARY
EOF

# 生成完整报告
cat > $REPORT_FILE << EOF
# 🦞 龙虾健康报告

**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')

---

## 📊 系统状态

| 指标 | 状态 | 详情 |
|------|------|------|
| 内存使用 | $MEMORY_STATUS | ${MEMORY_USED}% (${MEMORY_GB}) |
| 系统负载 | 🟢 | $LOAD_AVG |
| 磁盘使用 | $DISK_STATUS | ${DISK_USED} (${DISK_GB}) |
| 进程数量 | 🟢 | $PROCESS_COUNT 个 |

---

## 🤖 OpenClaw 服务

| 服务 | 状态 |
|------|------|
| Gateway | $([ "$GATEWAY_STATUS" = "active" ] && echo "🟢 运行中" || echo "🔴 $GATEWAY_STATUS") |
| Node | $([ "$NODE_STATUS" = "active" ] && echo "🟢 运行中" || echo "🔴 $NODE_STATUS") |

---

## 📝 其他指标

- **Git 未提交变更**: $([ $GIT_STATUS -eq 0 ] && echo "🟢 无" || echo "🟡 $GIT_STATUS 个文件")

---

## ✅ 总结

$([ "$GATEWAY_STATUS" = "active" ] && [ "$NODE_STATUS" = "active" ] && echo "**系统运行正常** 🎉" || echo "**需要关注** ⚠️")

---

*此报告由健康报告生成器自动创建*
EOF

echo "[$(date)] 健康报告已生成" >> $LOG_DIR/health-report-generator.log
