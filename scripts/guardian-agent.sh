#!/bin/bash

# OpenClaw 守护 Agent
# 功能：监控、诊断、自动修复
# 触发：定时（每10分钟）或手动

WORKSPACE="$HOME/.openclaw/workspace"
LOG_FILE="/tmp/guardian.log"
NOTIFY_FILE="/tmp/notify/guardian.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 日志函数
log() {
  echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

# 通知函数
notify() {
  mkdir -p /tmp/notify
  cat > "$NOTIFY_FILE" <<EOF
🛡️ 守护 Agent 报告

$1
EOF
}

# 初始化状态
ISSUES=0
FIXES=""
NEED_MANUAL=""

log "=========================================="
log "🛡️ 守护 Agent 开始检查"
log "=========================================="

# ============================================
# 1. 检查 OpenClaw Gateway
# ============================================
check_gateway() {
  log "1. 检查 OpenClaw Gateway..."
  
  if openclaw gateway status 2>&1 | grep -q "running"; then
    log "  ✅ Gateway 运行正常"
  else
    log "  ❌ Gateway 未运行，尝试重启..."
    openclaw gateway start >> "$LOG_FILE" 2>&1
    
    if openclaw gateway status 2>&1 | grep -q "running"; then
      log "  ✅ 重启成功"
      FIXES="$FIXES\n- 重启 Gateway"
      ISSUES=$((ISSUES + 1))
    else
      log "  ❌ 重启失败，需要人工干预"
      NEED_MANUAL="$NEED_MANUAL\n- Gateway 无法启动"
    fi
  fi
}

# ============================================
# 2. 检查内存
# ============================================
check_memory() {
  log "2. 检查内存..."
  
  local available=$(free -m | awk '/Mem:/ {print $7}')
  local swap_used=$(free -m | awk '/Swap:/ {print $3}')
  
  if [ "$available" -lt 100 ]; then
    log "  ❌ 内存严重不足：${available}MB"
    
    # 尝试清理缓存
    log "  尝试清理缓存..."
    sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
    
    local new_available=$(free -m | awk '/Mem:/ {print $7}')
    if [ "$new_available" -gt "$available" ]; then
      log "  ✅ 清理成功，可用内存：${new_available}MB"
      FIXES="$FIXES\n- 清理内存缓存（${available}MB → ${new_available}MB）"
      ISSUES=$((ISSUES + 1))
    else
      log "  ❌ 清理失败，需要人工干预"
      NEED_MANUAL="$NEED_MANUAL\n- 内存不足（${available}MB）"
    fi
  elif [ "$available" -lt 200 ]; then
    log "  ⚠️ 内存偏低：${available}MB"
  else
    log "  ✅ 内存正常：${available}MB 可用"
  fi
  
  if [ "$swap_used" -gt 500 ]; then
    log "  ⚠️ Swap 使用过高：${swap_used}MB"
  fi
}

# ============================================
# 3. 检查系统负载
# ============================================
check_load() {
  log "3. 检查系统负载..."
  
  local load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
  
  if (( $(echo "$load > 2.0" | bc -l) )); then
    log "  ❌ 系统负载过高：$load"
    
    # 找到高 CPU 进程
    local top_process=$(ps aux --sort=-%cpu | head -2 | tail -1)
    log "  高 CPU 进程：$top_process"
    NEED_MANUAL="$NEED_MANUAL\n- 系统负载过高（$load）"
  elif (( $(echo "$load > 1.0" | bc -l) )); then
    log "  ⚠️ 系统负载偏高：$load"
  else
    log "  ✅ 系统负载正常：$load"
  fi
}

# ============================================
# 4. 检查磁盘空间
# ============================================
check_disk() {
  log "4. 检查磁盘空间..."
  
  local available=$(df -h / | awk 'NR==2 {print $4}' | sed 's/G//')
  
  if (( $(echo "$available < 5" | bc -l) )); then
    log "  ❌ 磁盘空间不足：${available}GB"
    
    # 清理日志
    log "  尝试清理日志..."
    find /tmp -name "*.log" -size +10M -delete 2>/dev/null
    find /var/log -name "*.log" -size +50M -delete 2>/dev/null || true
    
    FIXES="$FIXES\n- 清理大日志文件"
    ISSUES=$((ISSUES + 1))
  elif (( $(echo "$available < 10" | bc -l) )); then
    log "  ⚠️ 磁盘空间偏低：${available}GB"
  else
    log "  ✅ 磁盘空间正常：${available}GB"
  fi
}

# ============================================
# 5. 检查网络连接
# ============================================
check_network() {
  log "5. 检查网络连接..."
  
  # 测试 DNS
  if nslookup github.com >> /dev/null 2>&1; then
    log "  ✅ DNS 解析正常"
  else
    log "  ❌ DNS 解析失败"
    NEED_MANUAL="$NEED_MANUAL\n- DNS 解析失败"
  fi
  
  # 测试外网连接
  if ping -c 1 8.8.8.8 >> /dev/null 2>&1; then
    log "  ✅ 外网连接正常"
  else
    log "  ❌ 外网连接失败"
    NEED_MANUAL="$NEED_MANUAL\n- 外网连接失败"
  fi
}

# ============================================
# 6. 检查 Git 锁文件
# ============================================
check_git_locks() {
  log "6. 检查 Git 锁文件..."
  
  local locks=$(find "$WORKSPACE" -name "*.lock" -type f 2>/dev/null | wc -l)
  
  if [ "$locks" -gt 0 ]; then
    log "  ⚠️ 发现 $locks 个 Git 锁文件，清理..."
    find "$WORKSPACE" -name "*.lock" -type f -delete 2>/dev/null
    FIXES="$FIXES\n- 清理 Git 锁文件（$locks 个）"
    ISSUES=$((ISSUES + 1))
  else
    log "  ✅ 无 Git 锁文件"
  fi
}

# ============================================
# 7. 检查僵尸进程
# ============================================
check_zombies() {
  log "7. 检查僵尸进程..."
  
  local zombies=$(ps aux | awk '$8 ~ /Z/ {print $2}' | wc -l)
  
  if [ "$zombies" -gt 5 ]; then
    log "  ⚠️ 发现 $zombies 个僵尸进程"
    NEED_MANUAL="$NEED_MANUAL\n- 僵尸进程过多（$zombies 个）"
  else
    log "  ✅ 僵尸进程数量正常（$zombies 个）"
  fi
}

# ============================================
# 生成报告
# ============================================
generate_report() {
  log "=========================================="
  log "🛡️ 检查完成"
  log "=========================================="
  log "发现问题：$ISSUES 个"
  
  if [ -n "$FIXES" ]; then
    log "已修复：$FIXES"
  fi
  
  if [ -n "$NEED_MANUAL" ]; then
    log "需要人工干预：$NEED_MANUAL"
    
    # 生成通知
    notify "❌ 发现问题需要人工干预

📊 检查结果：
- 发现问题：$ISSUES 个
- 已自动修复：$(echo -e "$FIXES" | grep -c "^-")
- 需要人工干预：$(echo -e "$NEED_MANUAL" | grep -c "^-")

⚠️ 需要处理：
$(echo -e "$NEED_MANUAL")

📋 详细日志：
  cat $LOG_FILE"
    
    exit 1
  elif [ $ISSUES -gt 0 ]; then
    notify "⚠️ 守护 Agent 已自动修复问题

📊 检查结果：
- 发现问题：$ISSUES 个
- 已自动修复

🔧 修复内容：
$(echo -e "$FIXES")"
  fi
  
  exit 0
}

# ============================================
# 主流程
# ============================================
main() {
  check_gateway
  check_memory
  check_load
  check_disk
  check_network
  check_git_locks
  check_zombies
  generate_report
}

# 执行
main
