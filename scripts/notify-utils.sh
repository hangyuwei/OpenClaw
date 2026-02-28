#!/bin/bash

# 统一通知工具函数
# 所有定时任务脚本都应该 source 这个文件

NOTIFY_DIR="/tmp/notify"

# 初始化通知目录
init_notify() {
  mkdir -p "$NOTIFY_DIR"
}

# 发送通知（每个任务调用）
# 参数：$1 = 任务名称，$2 = 通知内容文件
send_notify() {
  local task_name="$1"
  local content_file="$2"
  local notify_file="$NOTIFY_DIR/${task_name}-$(date +%s).txt"

  init_notify

  # 复制内容到通知文件
  cp "$content_file" "$notify_file"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 通知已生成：$notify_file" >> /tmp/notify.log
}

# 快速通知（直接传内容）
# 参数：$1 = 任务名称，$2 = 标题，$3 = 内容
quick_notify() {
  local task_name="$1"
  local title="$2"
  local content="$3"
  local notify_file="$NOTIFY_DIR/${task_name}-$(date +%s).txt"

  init_notify

  cat > "$notify_file" <<EOF
$title

$content
EOF

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 通知已生成：$notify_file" >> /tmp/notify.log
}
