#!/bin/bash
# 竞品监控 + 播客整理脚本
# 每天 8:00 运行

TAVILY_KEY="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"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
REPORT_DIR="$HOME/.openclaw/workspace/obsidian-vault/竞品监控"
LOG_FILE="/tmp/competitor-monitor.log"

# 创建目录
mkdir -p "$REPORT_DIR"

# 日志函数
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "========== 开始竞品监控 =========="

# ============================================
# 1. YouTube 竞品监控
# ============================================

log "开始 YouTube 竞品监控..."

# 定义要监控的频道（示例）
CHANNELS=(
  "Lex Fridman Podcast"
  "The Knowledge Project"
  "Acquired"
  "All-In Podcast"
  "My First Million"
)

# 保存结果
YOUTUBE_RESULTS=""

for CHANNEL in "${CHANNELS[@]}"; do
  log "搜索频道: $CHANNEL"

  # 使用 Tavily 搜索
  RESULT=$(export TAVILY_API_KEY="$TAVILY_KEY" && node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
    "site:youtube.com \"$CHANNEL\" podcast episode 2026" \
    -n 3 \
    --topic news \
    --days 7 2>&1)

  YOUTUBE_RESULTS+="$RESULT\n\n"
  sleep 2
done

log "YouTube 监控完成"

# ============================================
# 2. 播客内容整理
# ============================================

log "开始播客内容整理..."

# 搜索热门播客话题
PODCAST_TOPICS=(
  "AI trends 2026"
  "artificial intelligence podcast"
  "technology trends"
  "startup growth"
  "business strategy"
)

PODCAST_RESULTS=""

for TOPIC in "${PODCAST_TOPICS[@]}"; do
  log "搜索播客话题: $TOPIC"

  RESULT=$(export TAVILY_API_KEY="$TAVILY_KEY" && node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
    "\"$TOPIC\" podcast episode" \
    -n 5 \
    --topic news \
    --days 3 2>&1)

  PODCAST_RESULTS+="$RESULT\n\n"
  sleep 2
done

log "播客整理完成"

# ============================================
# 3. 生成报告
# ============================================

log "生成每日报告..."

REPORT_FILE="$REPORT_DIR/$DATE-竞品监控.md"

cat > "$REPORT_FILE" << EOF
# 竞品监控 + 播客整理 - $DATE

> 生成时间：$TIME
> 监控频率：每天 8:00
> 数据来源：YouTube + 播客平台

---

## 📊 YouTube 竞品监控

### 监控频道

$(for CH in "${CHANNELS[@]}"; do echo "- $CH"; done)

### 最新内容

$YOUTUBE_RESULTS

---

## 🎧 播客内容整理

### 热门话题

$(for TOPIC in "${PODCAST_TOPICS[@]}"; do echo "- $TOPIC"; done)

### 最新播客

$PODCAST_RESULTS

---

## 📈 今日洞察

### 高表现内容特征

- [ ] 标题关键词分析
- [ ] 时长分析
- [ ] 发布时间分析
- [ ] 互动率分析

### 可借鉴策略

1. **内容策略**
   - 待分析...

2. **发布策略**
   - 待分析...

3. **互动策略**
   - 待分析...

---

## 📅 后续行动

- [ ] 深入分析高表现内容
- [ ] 提取可复用模式
- [ ] 应用到自己的内容
- [ ] 监控效果反馈

---

**自动生成**：OpenClaw 竞品监控系统
**下次更新**：$(date -d "+1 day" +%Y-%m-%d)
EOF

log "报告已生成：$REPORT_FILE"

# ============================================
# 4. 同步到 Obsidian
# ============================================

log "同步到 Obsidian..."

cd ~/.openclaw/workspace/obsidian-vault

git add "竞品监控/$DATE-竞品监控.md"
git commit -m "📊 竞品监控 + 播客整理 - $DATE"
git push

log "Obsidian 同步完成"

# ============================================
# 5. 发送通知（可选）
# ============================================

log "发送通知..."

# 这里可以添加 Telegram 通知或其他通知方式

log "========== 竞品监控完成 =========="

echo "✅ 竞品监控完成！报告已保存到："
echo "📄 $REPORT_FILE"
