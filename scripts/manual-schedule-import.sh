#!/bin/bash
# 手动导入日程（无需 API）

WORKSPACE="$HOME/.openclaw/workspace"
SCHEDULE_DIR="$WORKSPACE/obsidian-vault/日程"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

mkdir -p "$SCHEDULE_DIR"

echo "📅 手动导入日程"
echo "================"
echo ""

# 交互式输入日程
echo "请输入今日日程（每行一个，输入空行结束）："
echo "格式：时间 | 主题 | 地点"
echo "示例：14:00 | 项目会议 | 3号会议室"
echo ""

SCHEDULES=()
while true; do
  read -p "> " LINE
  if [ -z "$LINE" ]; then
    break
  fi
  SCHEDULES+=("$LINE")
done

# 生成日程文件
SCHEDULE_FILE="$SCHEDULE_DIR/$DATE.md"

cat > "$SCHEDULE_FILE" << EOF
# 📅 日程安排 - $DATE

> 创建时间：$TIME
> 数据来源：手动输入

---

## 📋 今日日程

EOF

# 解析并添加日程
for SCHEDULE in "${SCHEDULES[@]}"; do
  TIME_PART=$(echo "$SCHEDULE" | cut -d'|' -f1 | xargs)
  TITLE=$(echo "$SCHEDULE" | cut -d'|' -f2 | xargs)
  LOCATION=$(echo "$SCHEDULE" | cut -d'|' -f3 | xargs)

  cat >> "$SCHEDULE_FILE" << EOF
### $TITLE
- **时间**：$TIME_PART
- **地点**：${LOCATION:-待定}
- **状态**：待完成

EOF
done

cat >> "$SCHEDULE_FILE" << EOF

---

## ⏰ 时间线

EOF

# 按时间排序并生成时间线
IFS=$'\n' SORTED_SCHEDULES=($(sort <<<"${SCHEDULES[*]}"))
unset IFS

for SCHEDULE in "${SORTED_SCHEDULES[@]}"; do
  TIME_PART=$(echo "$SCHEDULE" | cut -d'|' -f1 | xargs)
  TITLE=$(echo "$SCHEDULE" | cut -d'|' -f2 | xargs)

  echo "- $TIME_PART - $TITLE" >> "$SCHEDULE_FILE"
done

cat >> "$SCHEDULE_FILE" << EOF

---

## 💡 提醒事项

- [ ] 提前 15 分钟到达会议室
- [ ] 准备会议资料
- [ ] 确认设备正常

---

## 📊 统计信息

- 总日程数：${#SCHEDULES[@]}
- 会议数：待统计
- 外出数：待统计

---

**创建方式**：手动输入
**下次更新**：手动
EOF

echo ""
echo "✅ 日程已保存到：$SCHEDULE_FILE"
echo ""

# 同步到 Git
cd "$WORKSPACE/obsidian-vault"
git add "日程/$DATE.md"
git commit -m "📅 手动导入日程 - $DATE"
git push

echo "✅ 已同步到 GitHub"
echo ""
echo "📋 查看日程："
echo "  cat $SCHEDULE_FILE"
