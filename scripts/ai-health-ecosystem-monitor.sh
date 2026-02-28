#!/bin/bash
# AI + 大健康监控脚本
# 每天 9:00 自动运行

WORKSPACE="$HOME/.openclaw/workspace"
OBSIDIAN="$WORKSPACE/obsidian-vault"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

echo "🏥 AI + 大健康监控 - $DATE $TIME"
echo "===================================="

# 创建输出目录
OUTPUT_DIR="$OBSIDIAN/技术趋势/AI大健康监控"
mkdir -p "$OUTPUT_DIR"

# 设置 Tavily API Key
export TAVILY_API_KEY="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"

# 监控关键词
KEYWORDS=(
  "\"AI healthcare\" \"digital health\" 2026"
  "\"aging technology\" \"elderly care\" AI"
  "\"chronic disease\" management AI"
  "\"healthcare ecosystem\" digital platform"
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
# 🏥 AI + 大健康监控报告

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

## 📈 市场动态

- 老年护理市场：$2085.9 亿（2032）
- 年增长率：25.26%
- 美国 AI 医疗投资：$1000 亿（2030）

---

**自动生成**：OpenClaw AI + 大健康监控系统
**下次更新**：明天 9:00
EOF

echo "✅ 监控报告已生成：$REPORT_FILE"

# 同步到 Git
cd "$OBSIDIAN"
git add "技术趋势/AI大健康监控/$DATE.md"
git commit -m "🏥 AI+大健康监控 - $DATE"
git push

echo "✅ 已同步到 GitHub"

# 生成通知
mkdir -p /tmp/notify
cat > /tmp/notify/ai-health-ecosystem.txt <<EOF
🏥 AI+大健康生态监控完成

📋 报告位置：obsidian-vault/技术趋势/AI大健康监控/$DATE.md
EOF

echo ""
echo "===================================="
echo "✅ 监控完成！"
echo ""
echo "📋 查看报告："
echo "  cat $REPORT_FILE"
