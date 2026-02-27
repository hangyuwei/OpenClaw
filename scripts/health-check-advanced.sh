#!/bin/bash

# OpenClaw 自我保护脚本
# 用途：监控系统状态，预防卡死
# 运行频率：每 10 分钟

LOG_FILE="/tmp/openclaw-protection.log"
ALERT_FILE="/tmp/openclaw-alert.txt"
WORKSPACE="/home/ubuntu/.openclaw/workspace"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

alert() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚨 $1" > "$ALERT_FILE"
  log "🚨 警告：$1"
}

# 1. 检查内存
check_memory() {
  local available=$(free -m | awk '/Mem:/ {print $7}')
  local swap_used=$(free -m | awk '/Swap:/ {print $3}')

  if [ "$available" -lt 100 ]; then
    alert "内存严重不足：${available}MB 可用，Swap: ${swap_used}MB"
    return 1
  elif [ "$available" -lt 200 ]; then
    alert "内存偏低：${available}MB 可用，建议重启会话"
    return 1
  elif [ "$swap_used" -gt 500 ]; then
    alert "Swap 使用过高：${swap_used}MB，可能有内存泄漏"
    return 1
  fi

  log "内存正常：${available}MB 可用，Swap: ${swap_used}MB"
  return 0
}

# 2. 检查系统负载
check_load() {
  local load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')

  if (( $(echo "$load > 2.0" | bc -l) )); then
    alert "系统负载过高：$load"
    return 1
  elif (( $(echo "$load > 1.0" | bc -l) )); then
    log "⚠️ 系统负载偏高：$load"
    return 0
  fi

  log "系统负载正常：$load"
  return 0
}

# 3. 检查磁盘空间
check_disk() {
  local available=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

  if [ "$available" -lt 5 ]; then
    alert "磁盘空间不足：${available}GB 可用"
    return 1
  fi

  log "磁盘空间正常：${available}GB 可用"
  return 0
}

# 4. 清理锁文件
clean_locks() {
  local cleaned=0

  if [ -f "$WORKSPACE/.git/index.lock" ]; then
    rm -f "$WORKSPACE/.git/index.lock"
    cleaned=$((cleaned + 1))
  fi

  if [ -f "$WORKSPACE/obsidian-vault/.git/index.lock" ]; then
    rm -f "$WORKSPACE/obsidian-vault/.git/index.lock"
    cleaned=$((cleaned + 1))
  fi

  if [ $cleaned -gt 0 ]; then
    log "清理了 $cleaned 个锁文件"
  fi
}

# 5. 检查僵尸进程
check_zombies() {
  local zombies=$(ps aux | awk '$8 ~ /Z/ {print $2}' | wc -l)

  if [ "$zombies" -gt 5 ]; then
    alert "发现 $zombies 个僵尸进程"
    return 1
  fi

  return 0
}

# 6. 检查 OpenClaw 进程
check_openclaw() {
  local gateway_mem=$(ps aux | grep "openclaw-gateway" | grep -v grep | awk '{print $6}')
  local node_mem=$(ps aux | grep "openclaw-node" | grep -v grep | awk '{print $6}')

  if [ -n "$gateway_mem" ]; then
    gateway_mem=$((gateway_mem / 1024))
    if [ "$gateway_mem" -gt 600 ]; then
      alert "openclaw-gateway 内存占用过高：${gateway_mem}MB"
      return 1
    fi
    log "openclaw-gateway 内存：${gateway_mem}MB"
  fi

  if [ -n "$node_mem" ]; then
    node_mem=$((node_mem / 1024))
    log "openclaw-node 内存：${node_mem}MB"
  fi

  return 0
}

# 7. 生成健康报告
generate_report() {
  local report_file="/tmp/openclaw-health-report.txt"
  local available_mem=$(free -m | awk '/Mem:/ {print $7}')
  local swap_used=$(free -m | awk '/Swap:/ {print $3}')
  local load=$(uptime | awk -F'load average:' '{print $2}')
  local disk_avail=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

  cat > "$report_file" <<EOF
OpenClaw 系统健康报告
生成时间：$(date '+%Y-%m-%d %H:%M:%S')

内存状态：
- 可用内存：${available_mem}MB
- Swap 使用：${swap_used}MB

系统负载：
$load

磁盘空间：
- 可用空间：${disk_avail}GB

状态：$([ -f "$ALERT_FILE" ] && echo "⚠️ 有警告" || echo "✅ 正常")
EOF

  log "健康报告已生成：$report_file"
}

# 主流程
main() {
  log "========== 开始系统检查 =========="

  check_memory
  memory_status=$?

  check_load
  load_status=$?

  check_disk
  disk_status=$?

  clean_locks

  check_zombies
  zombie_status=$?

  check_openclaw
  openclaw_status=$?

  generate_report

  # 如果有严重问题，返回错误码
  if [ $memory_status -ne 0 ] || [ $disk_status -ne 0 ]; then
    log "❌ 系统检查失败，存在严重问题"
    exit 1
  fi

  log "✅ 系统检查完成"
  exit 0
}

# 执行
main
