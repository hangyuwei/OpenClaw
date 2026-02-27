#!/bin/bash
# AI 博主动态监控
# 每天早上 9:00 运行

TAVILY_KEY="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"
DATE=$(date +%Y-%m-%d)
REPORT_DIR="$HOME/.openclaw/workspace/obsidian-vault/AI博主动态"

mkdir -p "$REPORT_DIR"

echo "🎯 AI 博主动态监控 - $DATE"
echo "================================"

# 监控的关键博主
INFLUENCERS=(
  "Sam Altman"
  "Elon Musk"
  "Andrej Karpathy"
  "Andrew Ng"
  "Yann LeCun"
)

RESULTS=""

for PERSON in "${INFLUENCERS[@]}"; do
  echo "监控：$PERSON"
  
  RESULT=$(export TAVILY_API_KEY="$TAVILY_KEY" && node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
    "\"$PERSON\" AI news latest 2026" \
    -n 3 \
    --topic news \
    --days 1 2>&1)
  
  RESULTS+="# $PERSON\n\n$RESULT\n\n---\n\n"
  
  sleep 2
done

# 生成报告
REPORT_FILE="$REPORT_DIR/$DATE.md"

cat > "$REPORT_FILE" << EOF
# AI 博主动态 - $DATE

> 监控频率：每天 9:00
> 监控对象：5 位核心博主

---

$RESULTS

---

**自动生成**：OpenClaw AI 博主监控系统
