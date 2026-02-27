#!/bin/bash

# OpenClaw 快速自检脚本
# 用途：在大操作前快速检查系统状态
# 使用：source ~/.openclaw/workspace/scripts/quick-check.sh

# 颜色定义
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 检查内存
check_memory() {
  local available=$(free -m | awk '/Mem:/ {print $7}')

  if [ "$available" -lt 100 ]; then
    echo -e "${RED}❌ 内存严重不足：${available}MB 可用${NC}"
    return 1
  elif [ "$available" -lt 200 ]; then
    echo -e "${YELLOW}⚠️ 内存偏低：${available}MB 可用${NC}"
    return 2
  else
    echo -e "${GREEN}✅ 内存正常：${available}MB 可用${NC}"
    return 0
  fi
}

# 检查负载
check_load() {
  local load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')

  if (( $(echo "$load > 2.0" | bc -l) )); then
    echo -e "${RED}❌ 系统负载过高：$load${NC}"
    return 1
  elif (( $(echo "$load > 1.0" | bc -l) )); then
    echo -e "${YELLOW}⚠️ 系统负载偏高：$load${NC}"
    return 2
  else
    echo -e "${GREEN}✅ 系统负载正常：$load${NC}"
    return 0
  fi
}

# 检查磁盘
check_disk() {
  local available=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

  if [ "$available" -lt 5 ]; then
    echo -e "${RED}❌ 磁盘空间不足：${available}GB 可用${NC}"
    return 1
  elif [ "$available" -lt 10 ]; then
    echo -e "${YELLOW}⚠️ 磁盘空间偏低：${available}GB 可用${NC}"
    return 2
  else
    echo -e "${GREEN}✅ 磁盘空间正常：${available}GB 可用${NC}"
    return 0
  fi
}

# 检查锁文件
check_locks() {
  local locks=0

  if [ -f "$HOME/.openclaw/workspace/.git/index.lock" ]; then
    echo -e "${YELLOW}⚠️ 发现 Git 锁文件：workspace/.git/index.lock${NC}"
    locks=$((locks + 1))
  fi

  if [ -f "$HOME/.openclaw/workspace/obsidian-vault/.git/index.lock" ]; then
    echo -e "${YELLOW}⚠️ 发现 Git 锁文件：obsidian-vault/.git/index.lock${NC}"
    locks=$((locks + 1))
  fi

  if [ $locks -eq 0 ]; then
    echo -e "${GREEN}✅ 无锁文件${NC}"
    return 0
  else
    echo -e "${YELLOW}⚠️ 发现 $locks 个锁文件，建议清理${NC}"
    return 2
  fi
}

# 快速检查所有
quick_check() {
  echo "🔍 OpenClaw 系统快速检查"
  echo "========================"

  local status=0

  check_memory
  [ $? -eq 1 ] && status=1

  check_load
  [ $? -eq 1 ] && status=1

  check_disk
  [ $? -eq 1 ] && status=1

  check_locks
  [ $? -eq 1 ] && status=1

  echo "========================"

  if [ $status -eq 0 ]; then
    echo -e "${GREEN}✅ 系统状态良好，可以执行大操作${NC}"
    return 0
  else
    echo -e "${RED}❌ 系统存在问题，建议先修复${NC}"
    return 1
  fi
}

# 如果直接运行（非 source）
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  quick_check
fi
