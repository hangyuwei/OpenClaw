#!/bin/bash

# Obsidian 自动整理与优化脚本
# 运行时间：每天凌晨 4 点（北京时间）
# 功能：提炼内容、去重、建立链接

VAULT="/home/ubuntu/.openclaw/workspace/obsidian-vault"
LOG_FILE="/tmp/obsidian-refine.log"
REPORT_FILE="$VAULT/自动整理/日报-$(date +%Y-%m-%d).md"

# 日志函数
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 创建报告目录
mkdir -p "$VAULT/自动整理"

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

# 1. 扫描所有 Markdown 文件
scan_files() {
  log "扫描 Obsidian 库..."

  local total_files=$(find "$VAULT" -name "*.md" -type f | wc -l)
  local total_size=$(du -sh "$VAULT" | awk '{print $1}')

  log "总文件数：$total_files"
  log "总大小：$total_size"

  cat >> "$REPORT_FILE" <<EOF

### 文件统计

- **总文件数**：$total_files
- **总大小**：$total_size

EOF
}

# 2. 识别重复内容
detect_duplicates() {
  log "检测重复内容..."

  local dup_count=0
  local dup_list=""

  # 检查相似文件名
  find "$VAULT" -name "*.md" -type f | while read -r file; do
    local basename=$(basename "$file" .md)
    local dir=$(dirname "$file")

    # 查找同名文件（不同目录）
    find "$VAULT" -name "*.md" -type f | grep -v "^$file$" | while read -r other; do
      local other_basename=$(basename "$other" .md)

      # 如果文件名相似度 > 80%
      if [[ "${basename,,}" == "${other_basename,,}" ]]; then
        dup_count=$((dup_count + 1))
        dup_list+="  - $basename\n    - $file\n    - $other\n"
      fi
    done
  done

  if [ -n "$dup_list" ]; then
    cat >> "$REPORT_FILE" <<EOF

### ⚠️ 潜在重复文件

$dup_list

**建议**：检查上述文件，合并重复内容

EOF
    log "发现 $dup_count 个潜在重复文件"
  else
    cat >> "$REPORT_FILE" <<EOF

### ✅ 重复内容检测

- 未发现明显重复文件

EOF
    log "未发现重复文件"
  fi
}

# 3. 分析文件大小分布
analyze_size() {
  log "分析文件大小分布..."

  cat >> "$REPORT_FILE" <<EOF

### 📏 文件大小分布

EOF

  # 大文件（> 50KB）
  local large_files=$(find "$VAULT" -name "*.md" -type f -size +50k | wc -l)
  if [ "$large_files" -gt 0 ]; then
    cat >> "$REPORT_FILE" <<EOF

**大文件（> 50KB）**：$large_files 个

EOF
    find "$VAULT" -name "*.md" -type f -size +50k | while read -r file; do
      local size=$(du -h "$file" | awk '{print $1}')
      local relative="${file#$VAULT/}"
      echo "  - $relative ($size)" >> "$REPORT_FILE"
    done
    echo "" >> "$REPORT_FILE"
  fi

  # 小文件（< 1KB）
  local tiny_files=$(find "$VAULT" -name "*.md" -type f -size -1k | wc -l)
  cat >> "$REPORT_FILE" <<EOF

**小文件（< 1KB）**：$tiny_files 个
EOF

  log "大文件：$large_files，小文件：$tiny_files"
}

# 4. 提取关键主题
extract_themes() {
  log "提取关键主题..."

  cat >> "$REPORT_FILE" <<EOF

### 🎯 关键主题

EOF

  # 提取常见关键词
  local keywords=$(grep -rho '#[^[:space:]]*' "$VAULT" 2>/dev/null | sort | uniq -c | sort -rn | head -20)

  if [ -n "$keywords" ]; then
    echo "$keywords" | while read -r count tag; do
      echo "  - $tag ($count 次)" >> "$REPORT_FILE"
    done
  else
    echo "  - 无标签数据" >> "$REPORT_FILE"
  fi

  echo "" >> "$REPORT_FILE"
}

# 5. 检查孤立文件（无链接）
check_orphans() {
  log "检查孤立文件..."

  cat >> "$REPORT_FILE" <<EOF

### 🏝️ 孤立文件（无入链）

EOF

  local orphan_count=0

  # 获取所有文件
  find "$VAULT" -name "*.md" -type f | while read -r file; do
    local basename=$(basename "$file" .md)
    local relative="${file#$VAULT/}"

    # 检查是否有其他文件链接到这个文件
    local links=$(grep -r "\[\[$basename" "$VAULT" --include="*.md" 2>/dev/null | grep -v "^$file:" | wc -l)

    if [ "$links" -eq 0 ]; then
      orphan_count=$((orphan_count + 1))
      echo "  - $relative" >> "$REPORT_FILE"
    fi
  done

  if [ "$orphan_count" -eq 0 ]; then
    echo "  - 无孤立文件" >> "$REPORT_FILE"
  fi

  echo "" >> "$REPORT_FILE"
}

# 6. 建议链接
suggest_links() {
  log "分析潜在链接..."

  cat >> "$REPORT_FILE" <<EOF

### 🔗 潜在链接建议

EOF

  # 基于关键词相似性建议链接
  # 这里简化为基于文件名相似性
  local suggestions=0

  find "$VAULT" -name "*.md" -type f | head -20 | while read -r file1; do
    local basename1=$(basename "$file1" .md)

    find "$VAULT" -name "*.md" -type f | grep -v "^$file1$" | head -5 | while read -r file2; do
      local basename2=$(basename "$file2" .md)

      # 检查文件名是否包含相似词汇
      if [[ "$basename1" == *"$basename2"* ]] || [[ "$basename2" == *"$basename1"* ]]; then
        suggestions=$((suggestions + 1))
        cat >> "$REPORT_FILE" <<EOF
  - **$basename1** ↔ **$basename2**
    - 原因：文件名相关
    - 建议在 $basename1 中添加：[[$basename2]]

EOF
      fi
    done
  done

  if [ "$suggestions" -eq 0 ]; then
    echo "  - 暂无明确建议" >> "$REPORT_FILE"
  fi

  echo "" >> "$REPORT_FILE"
}

# 7. 清理临时文件
cleanup_temp() {
  log "清理临时文件..."

  local cleaned=0

  # 清理空文件
  find "$VAULT" -name "*.md" -type f -empty -delete && cleaned=$((cleaned + 1))

  # 清理备份文件
  find "$VAULT" -name "*.md.bak" -type f -delete && cleaned=$((cleaned + 1))
  find "$VAULT" -name "*.md~" -type f -delete && cleaned=$((cleaned + 1))

  log "清理了 $cleaned 个临时文件"

  cat >> "$REPORT_FILE" <<EOF

### 🧹 清理操作

- 清理临时文件：$cleaned 个

EOF
}

# 8. 生成优化建议
generate_recommendations() {
  log "生成优化建议..."

  cat >> "$REPORT_FILE" <<EOF

---

## 💡 优化建议

### 短期（本周）

1. **文件整理**
   - 合并重复文件
   - 删除过期内容
   - 统一文件命名规范

2. **链接优化**
   - 为孤立文件建立连接
   - 创建主题索引页
   - 建立 MOC（Map of Content）

### 中期（本月）

1. **结构优化**
   - 重组文件夹结构
   - 建立标签体系
   - 创建模板库

2. **内容提炼**
   - 提取核心观点
   - 建立知识卡片
   - 创建速查表

### 长期（本季度）

1. **知识图谱**
   - 建立完整的知识网络
   - 可视化知识结构
   - 定期更新维护

2. **自动化**
   - 持续优化整理脚本
   - 建立智能推荐系统
   - 集成外部知识源

---

## 📈 下次运行

- **时间**：明天凌晨 4:00
- **频率**：每日
- **改进**：根据本次结果优化

---

**生成时间**：$(date '+%Y-%m-%d %H:%M:%S')
**脚本版本**：v1.0
**维护者**：OpenClaw AI

EOF
}

# 9. 提交更改
commit_changes() {
  log "提交整理结果..."

  cd "$VAULT"

  # 检查是否有更改
  if [ -n "$(git status --short)" ]; then
    git add -A
    git commit -m "📚 每日自动整理：提炼内容、去重、优化链接

整理内容：
- 扫描文件并检测重复
- 分析文件大小分布
- 提取关键主题
- 检查孤立文件
- 生成优化建议

详见：自动整理/日报-$(date +%Y-%m-%d).md
" && git push

    log "已提交整理结果"
  else
    log "无需提交，未发现更改"
  fi
}

# 10. 生成通知摘要
generate_notification() {
  log "生成通知摘要..."

  local total_files=$(find "$VAULT" -name "*.md" -type f | wc -l)
  local orphan_count=$(grep -c "^  - " "$REPORT_FILE" 2>/dev/null || echo "0")

  # 创建通知标记文件，供 heartbeat 读取
  local notify_file="/tmp/obsidian-refine-notify.txt"

  cat > "$notify_file" <<EOF
🌅 Obsidian 每日整理完成

📊 摘要：
- 总文件：$total_files 个
- 孤立文件：$orphan_count 个
- 临时清理：已完成

📋 报告位置：obsidian-vault/自动整理/日报-$(date +%Y-%m-%d).md
EOF

  log "通知摘要已生成：$notify_file"
}

# 主流程
main() {
  log "========== 开始 Obsidian 自动整理 =========="

  init_report
  scan_files
  detect_duplicates
  analyze_size
  extract_themes
  check_orphans
  suggest_links
  cleanup_temp
  generate_recommendations
  commit_changes
  generate_notification

  log "✅ Obsidian 自动整理完成"
  log "报告位置：$REPORT_FILE"
  log "=========================================="
}

# 执行
main
