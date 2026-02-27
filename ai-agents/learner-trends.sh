#!/bin/bash
# 学习专员 v2.0
# 每 2 小时深度学习最新技术趋势

WORKSPACE="$HOME/.openclaw/workspace"
OBSIDIAN="$WORKSPACE/obsidian-vault"
TAVILY_KEY="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"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

echo "📚 深度学习系统 - $DATE $TIME"
echo "================================"

# 创建输出目录
mkdir -p "$OBSIDIAN/学习记录"
mkdir -p "$OBSIDIAN/科技巨头监控"
mkdir -p "$OBSIDIAN/Reddit热议"
mkdir -p "$OBSIDIAN/X话题追踪"

export TAVILY_API_KEY="$TAVILY_KEY"

# 1. AI 趋势深度学习
echo "🤖 学习 AI 最新趋势..."
AI_TRENDS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "\"artificial intelligence\" latest breakthroughs research 2026" \
  -n 10 \
  --topic news \
  --days 2 2>&1)

# 2. 七大科技巨头监控
echo "🏢 监控七大科技巨头..."
TECH_GIANTS=(
  "Apple"
  "Microsoft"
  "NVIDIA"
  "Google"
  "Amazon"
  "Meta"
  "Tesla"
)

TECH_REPORT=""
for COMPANY in "${TECH_GIANTS[@]}"; do
  echo "  - $COMPANY"
  RESULT=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
    "\"$COMPANY\" AI news technology 2026" \
    -n 3 \
    --topic news \
    --days 1 2>&1)
  TECH_REPORT+="# $COMPANY\n\n$RESULT\n\n---\n\n"
  sleep 1
done

# 3. Reddit 热议话题
echo "📱 抓取 Reddit AI 热议..."
REDDIT_TOPICS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:reddit.com AI artificial intelligence discussion 2026" \
  -n 10 \
  --topic news \
  --days 1 2>&1)

# 4. X/Twitter 热门话题
echo "🐦 追踪 X/Twitter AI 话题..."
X_TRENDS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "\"AI trends\" \"artificial intelligence\" \"machine learning\" latest 2026" \
  -n 10 \
  --topic news \
  --days 1 2>&1)

# 生成综合学习报告
LEARNING_FILE="$OBSIDIAN/学习记录/$DATE-$TIME-深度学习.md"

cat > "$LEARNING_FILE" << EOF
# 📚 深度学习报告 - $DATE $TIME

> 学习频率：每 2 小时
> 学习深度：⭐⭐⭐⭐⭐
> 数据来源：Tavily AI

---

## 🤖 AI 最新突破

$AI_TRENDS

---

## 🏢 七大科技巨头动态

$TECH_REPORT

---

## 📱 Reddit 热议

$REDDIT_TOPICS

---

## 🐦 X/Twitter 趋势

$X_TRENDS

---

## 💡 关键洞察

待分析...

---

## 🎯 行动建议

待生成...

---

**自动生成**：OpenClaw 深度学习系统
**下次更新**：2 小时后
EOF

echo "✅ 学习报告已生成：$LEARNING_FILE"

# 同步到 Git
cd "$OBSIDIAN"
git add -A
git commit -m "📚 深度学习 - $DATE $TIME"
git push

echo "✅ 已同步到 GitHub"

echo ""
echo "================================"
echo "✅ 深度学习完成！"
echo ""
echo "📋 查看报告："
echo "  cat $LEARNING_FILE"
