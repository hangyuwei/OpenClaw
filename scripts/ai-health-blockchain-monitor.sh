#!/bin/bash
# AI + 健康 + 区块链监控脚本
# 每天自动获取最新案例和趋势

WORKSPACE="$HOME/.openclaw/workspace"
OBSIDIAN="$WORKSPACE/obsidian-vault"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

echo "🏥 AI + 健康 + 区块链监控 - $DATE $TIME"
echo "=========================================="

# 创建输出目录
OUTPUT_DIR="$OBSIDIAN/技术趋势/AI健康区块链监控"
mkdir -p "$OUTPUT_DIR"

# 设置 Tavily API Key
export TAVILY_API_KEY="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"

# 监控关键词
KEYWORDS=(
  "\"AI healthcare\" real cases 2026"
  "\"blockchain medical\" applications"
  "\"AI diagnosis\" hospital"
  "\"healthcare AI\" success stories"
)

RESULTS=""

# 搜索最新信息
for KEYWORD in "${KEYWORDS[@]}"; do
  echo "🔍 搜索：$KEYWORD"

  RESULT=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
    "$KEYWORD" \
    -n 5 \
    --topic news \
    --days 7 2>&1)

  RESULTS+="# 搜索：$KEYWORD\n\n$RESULT\n\n---\n\n"

  sleep 2
done

# 生成监控报告
REPORT_FILE="$OUTPUT_DIR/$DATE.md"

cat > "$REPORT_FILE" << EOF
# AI + 健康 + 区块链监控报告

> 监控时间：$DATE $TIME
> 监控频率：每天
> 数据来源：Tavily AI

---

## 📊 今日发现

$RESULTS

---

## 💡 关键洞察

待分析...

---

## 🎯 行动建议

待生成...

---

**自动生成**：OpenClaw AI 健康监控系统
EOF

echo "✅ 监控报告已生成：$REPORT_FILE"

# 同步到 Git
cd "$OBSIDIAN"
git add "技术趋势/AI健康区块链监控/$DATE.md"
git commit -m "🏥 AI+健康+区块链监控 - $DATE"
git push

echo "✅ 已同步到 GitHub"

# 生成通知
mkdir -p /tmp/notify
cat > /tmp/notify/ai-health-blockchain.txt <<EOF
🏥 AI+健康+区块链监控完成

📋 报告位置：obsidian-vault/技术趋势/AI健康区块链监控/$DATE.md
EOF

echo ""
echo "=========================================="
echo "✅ 监控完成！"
echo ""
echo "📋 查看报告："
echo "  cat $REPORT_FILE"
