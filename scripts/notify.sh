#!/bin/bash

# 通用通知函数库
# 所有定时任务脚本都应该 source 这个文件：source ~/.openclaw/workspace/scripts/notify.sh

NOTIFY_DIR="/tmp/notify"

# 初始化通知目录
init_notify() {
  mkdir -p "$NOTIFY_DIR"
}

# 发送通知
# 用法：send_notify "任务名称" "标题" "内容"
send_notify() {
  local task_name="$1"
  local title="$2"
  local content="$3"

  init_notify

  local notify_file="$NOTIFY_DIR/${task_name}.txt"

  cat > "$notify_file" <<EOF
$title

$content
EOF

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 通知已生成：$notify_file" >> /tmp/notify.log
}

# 追加通知内容
# 用法：append_notify "任务名称" "内容"
append_notify() {
  local task_name="$1"
  local content="$2"

  local notify_file="$NOTIFY_DIR/${task_name}.txt"

  if [ -f "$notify_file" ]; then
    echo "$content" >> "$notify_file"
  fi
}

# 读取通知（供 heartbeat 使用）
read_notify() {
  local task_name="$1"
  local notify_file="$NOTIFY_DIR/${task_name}.txt"

  if [ -f "$notify_file" ]; then
    cat "$notify_file"
  fi
}

# 删除通知（发送后清理）
clear_notify() {
  local task_name="$1"
  local notify_file="$NOTIFY_DIR/${task_name}.txt"

  if [ -f "$notify_file" ]; then
    rm "$notify_file"
  fi
}

# 列出所有待发送通知
list_pending_notifies() {
  init_notify
  ls -1 "$NOTIFY_DIR"/*.txt 2>/dev/null || true
}
