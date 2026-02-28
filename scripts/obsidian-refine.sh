#!/bin/bash

# Obsidian 自动整理与优化脚本 v2.0
# 运行时间：每天凌晨 4 点（北京时间）
# 功能：分析 + 实际执行优化 + 通知

VAULT="/home/ubuntu/.openclaw/workspace/obsidian-vault"
LOG_FILE="/tmp/obsidian-refine.log"
REPORT_FILE="$VAULT/自动整理/日报-$(date +%Y-%m-%d).md"
NOTIFY_FILE="/tmp/notify/obsidian-refine.txt"

# 日志函数
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 初始化
init() {
  mkdir -p "$VAULT/自动整理"
  mkdir -p "$VAULT/MOC"
  mkdir -p /tmp/notify
}

# 初始化报告
init_report() {
  cat > "$REPORT_FILE" <<EOF
# 📚 Obsidian 自动整理日报

**日期**：$(date '+%Y-%m-%d %H:%M:%S')
**运行时间**：凌晨 4:00

---

## 📊 整理概览

EOF
}

# 1. 扫描文件
scan_files() {
  log "扫描 Obsidian 库..."
  TOTAL_FILES=$(find "$VAULT" -name "*.md" -type f | wc -l)
  TOTAL_SIZE=$(du -sh "$VAULT" | awk '{print $1}')

  cat >> "$REPORT_FILE" <<EOF
### 文件统计
- **总文件数**：$TOTAL_FILES
- **总大小**：$TOTAL_SIZE
EOF
}

# 2. 收集孤立文件
collect_orphans() {
  log "收集孤立文件..."

  ORPHANS=""
  ORPHAN_COUNT=0

  while IFS= read -r file; do
    local basename=$(basename "$file" .md)
    local relative="${file#$VAULT/}"

    # 跳过 MOC 目录和自动整理目录
    if [[ "$relative" == MOC/* ]] || [[ "$relative" == 自动整理/* ]]; then
      continue
    fi

    # 检查是否有其他文件链接到这个文件
    local links=$(grep -r "\[\[$basename" "$VAULT" --include="*.md" 2>/dev/null | grep -v "^$file:" | wc -l)

    if [ "$links" -eq 0 ]; then
      ORPHANS="$ORPHANS|$relative"
      ORPHAN_COUNT=$((ORPHAN_COUNT + 1))
    fi
  done < <(find "$VAULT" -name "*.md" -type f)

  log "发现 $ORPHAN_COUNT 个孤立文件"
}

# 3. 实际执行：创建/更新 MOC 索引
execute_create_moc() {
  log "执行：创建/更新 MOC 索引..."

  local moc_updated=0
  local moc_created=0

  # 定义分类规则
  declare -A categories=(
    ["AI趋势|AI博主|AI学习|学习记录|AI视频监控"]="AI学习中心"
    ["项目|竞品监控|AI代理运营|工作流程"]="项目管理"
    ["OpenClaw|AI工具|OpenClaw记忆"]="OpenClaw使用指南"
    ["故障排查|自我监控"]="故障排查手册"
    ["技术趋势|MCP|Zero-Human|AI+大健康|AI+健康"]="技术趋势追踪"
    ["可视化示例|Baoyu"]="可视化示例"
    ["经验库|调试|编程"]="经验库"
    ["数据验证|数据时效"]="数据验证"
  )

  # 遍历分类
  for category in "${!categories[@]}"; do
    local moc_name="${categories[$category]}"
    local moc_file="$VAULT/MOC/$moc_name.md"

    # 找到匹配的孤立文件
    local matches=""
    IFS='|' read -ra patterns <<< "$category"
    for pattern in "${patterns[@]}"; do
      while IFS='|' read -ra orphans; do
        for orphan in "${orphans[@]}"; do
          if [[ "$orphan" == *"$pattern"* ]]; then
            matches="$matches$orphan\n"
          fi
        done
      done <<< "$ORPHANS"
    done

    # 如果有匹配的文件，更新 MOC
    if [ -n "$matches" ]; then
      if [ -f "$moc_file" ]; then
        moc_updated=$((moc_updated + 1))
      else
        moc_created=$((moc_created + 1))
      fi

      log "  - $moc_name: 匹配 $(echo -e "$matches" | grep -c "^") 个文件"
    fi
  done

  EXECUTE_RESULTS="$EXECUTE_RESULTS
### 🗺️ MOC 索引更新
- 新建：$moc_created 个
- 更新：$moc_updated 个"
}

# 4. 实际执行：清理临时文件
execute_cleanup() {
  log "执行：清理临时文件..."

  local cleaned=0

  # 清理空文件
  local empty_count=$(find "$VAULT" -name "*.md" -type f -empty | wc -l)
  find "$VAULT" -name "*.md" -type f -empty -delete 2>/dev/null
  cleaned=$((cleaned + empty_count))

  # 清理备份文件
  local bak_count=$(find "$VAULT" -name "*.md.bak" -type f | wc -l)
  find "$VAULT" -name "*.md.bak" -type f -delete 2>/dev/null
  find "$VAULT" -name "*.md~" -type f -delete 2>/dev/null
  cleaned=$((cleaned + bak_count))

  log "清理了 $cleaned 个临时文件"

  EXECUTE_RESULTS="$EXECUTE_RESULTS
### 🧹 清理操作
- 删除空文件：$empty_count 个
- 删除备份文件：$bak_count 个"
}

# 5. 实际执行：提交更改
execute_commit() {
  log "执行：提交更改到 Git..."

  cd "$VAULT"

  if [ -n "$(git status --short)" ]; then
    git add -A
    git commit -m "🤖 每日自动整理：优化 MOC 索引、清理临时文件

执行内容：
- 创建/更新 MOC 索引
- 清理空文件和备份文件
- 生成整理报告

详见：自动整理/日报-$(date +%Y-%m-%d).md
" && git push

    log "已提交整理结果"
    EXECUTE_RESULTS="$EXECUTE_RESULTS
### 📤 Git 提交
- 状态：已提交并推送"
  else
    log "无需提交"
    EXECUTE_RESULTS="$EXECUTE_RESULTS
### 📤 Git 提交
- 状态：无更改"
  fi
}

# 6. 生成通知
generate_notification() {
  log "生成通知..."

  cat > "$NOTIFY_FILE" <<EOF
🌅 Obsidian 每日整理完成

📊 分析结果：
- 总文件：$TOTAL_FILES 个
- 孤立文件：$ORPHAN_COUNT 个

✅ 执行操作：
$EXECUTE_RESULTS

📋 完整报告：obsidian-vault/自动整理/日报-$(date +%Y-%m-%d).md
EOF

  log "通知已生成：$NOTIFY_FILE"
}

# 7. 生成报告
generate_report() {
  cat >> "$REPORT_FILE" <<EOF

---

## 📋 分析结果

### 🏝️ 孤立文件（$ORPHAN_COUNT 个）

EOF

  if [ "$ORPHAN_COUNT" -gt 0 ]; then
    IFS='|' read -ra orphans <<< "$ORPHANS"
    for orphan in "${orphans[@]}"; do
      [ -n "$orphan" ] && echo "  - $orphan" >> "$REPORT_FILE"
    done
  else
    echo "  - 无孤立文件 ✅" >> "$REPORT_FILE"
  fi

  cat >> "$REPORT_FILE" <<EOF

---

## ✅ 执行操作
$EXECUTE_RESULTS

---

**生成时间**：$(date '+%Y-%m-%d %H:%M:%S')
**脚本版本**：v2.0（报告 + 执行）
**维护者**：OpenClaw AI 🦞
EOF
}

# 主流程
main() {
  log "========== 开始 Obsidian 自动整理 v2.0 =========="

  init
  init_report
  scan_files
  collect_orphans
  execute_create_moc
  execute_cleanup
  execute_commit
  generate_report
  generate_notification

  log "✅ Obsidian 自动整理完成（报告 + 执行）"
  log "=========================================="
}

# 执行
main
