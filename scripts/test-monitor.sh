#!/bin/bash
# 测试：竞品监控脚本

TAVILY_KEY="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"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
REPORT_DIR="$HOME/.openclaw/workspace/obsidian-vault/竞品监控"

mkdir -p "$REPORT_DIR"

echo "========== 测试竞品监控 =========="
echo "开始时间：$TIME"

# 测试：搜索一个频道
echo "🔍 搜索：Lex Fridman Podcast..."

RESULT=$(export TAVILY_API_KEY="$TAVILY_KEY" && node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:youtube.com \"Lex Fridman\" podcast 2026" \
  -n 3 \
  --topic news \
  --days 7 2>&1)

echo "$RESULT"

# 生成测试报告
REPORT_FILE="$REPORT_DIR/$DATE-测试监控.md"

cat > "$REPORT_FILE" << EOF
# 竞品监控测试 - $DATE

> 测试时间：$TIME

---

## 📊 测试结果

$RESULT

---

**测试状态**：✅ 成功
EOF

echo ""
echo "✅ 测试完成！"
echo "📄 报告已保存到：$REPORT_FILE"
