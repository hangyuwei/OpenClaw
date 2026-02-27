#!/bin/bash
# 学习专员
# 每 6 小时学习最新技术趋势

WORKSPACE="$HOME/.openclaw/workspace"
TAVILY_KEY="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"
DATE=$(date +%Y-%m-%d)

# 学习 AI 趋势
export TAVILY_API_KEY="$TAVILY_KEY"
node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "AI artificial intelligence latest trends 2026" \
  -n 5 \
  --topic news \
  --days 1 > "$WORKSPACE/obsidian-vault/学习记录/$DATE-AI趋势.md"
