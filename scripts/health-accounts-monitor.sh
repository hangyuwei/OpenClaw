#!/bin/bash

# 健康医疗公众号监控
# 每天自动抓取指定公众号的最新发布

WORKSPACE="$HOME/.openclaw/workspace"
OBSIDIAN="$WORKSPACE/obsidian-vault"
TAVILY_KEY="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"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

echo "🏥 健康医疗公众号监控 - $DATE $TIME"
echo "========================================"

# 创建输出目录
mkdir -p "$OBSIDIAN/公众号监控"
mkdir -p "$OBSIDIAN/公众号监控/每日报告"

export TAVILY_API_KEY="$TAVILY_KEY"

REPORT_FILE="$OBSIDIAN/公众号监控/每日报告/$DATE.md"

# 公众号列表
ACCOUNTS=(
  "丁香医生"
  "丁香园"
  "丁香妈妈"
  "丁香生活研究"
  "鹤立烟雨"
  "文小叔说"
  "温暖中医"
  "粤卫平台"
  "drpei"
  "约苗"
)

# 初始化报告
cat > "$REPORT_FILE" <<EOF
# 🏥 健康医疗公众号监控

**日期**：$DATE $TIME
**监控数量**：${#ACCOUNTS[@]} 个公众号

---

## 📰 今日发布

EOF

# 监控每个公众号
total_articles=0

for account in "${ACCOUNTS[@]}"; do
  echo ""
  echo "📱 监控：$account"
  echo "--------------------------------"

  cat >> "$REPORT_FILE" <<EOF

### $account

EOF

  # 搜索该公众号的最新文章（使用更宽泛的搜索）
  result=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
    "\"$account\" 微信公众号 2026" \
    -n 5 \
    --topic news \
    --days 7 2>&1)

  # 解析结果
  article_count=$(echo "$result" | grep -o "\"url\"" | wc -l)

  if [ "$article_count" -gt 0 ]; then
    echo "$result" | grep -A 3 "\"title\"" | head -20 >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    total_articles=$((total_articles + article_count))
    echo "  找到 $article_count 篇文章"
  else
    echo "  暂无更新" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "  暂无更新"
  fi
done

# 添加统计
cat >> "$REPORT_FILE" <<EOF

---

## 📊 今日统计

- **监控公众号**：${#ACCOUNTS[@]} 个
- **发现文章**：$total_articles 篇

---

## 🔗 快速访问

### 丁香系列
- [丁香医生](https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MjA1ODMxMDQ0MQ==)
- [丁香园](https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MTg1MzU1NTY0MQ==)
- [丁香妈妈](https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MjM5NTcxODM0MA==)

### 中医系列
- [鹤立烟雨](https://mp.weixin.qq.com/)
- [文小叔说](https://mp.weixin.qq.com/)
- [温暖中医](https://mp.weixin.qq.com/)

### 医疗资讯
- [粤卫平台](https://mp.weixin.qq.com/)
- [drpei](https://mp.weixin.qq.com/)
- [约苗](https://mp.weixin.qq.com/)

---

**自动生成**：OpenClaw 健康医疗公众号监控
**下次更新**：明天同一时间
EOF

echo ""
echo "✅ 监控报告已生成：$REPORT_FILE"

# 同步到 Git
cd "$OBSIDIAN"
git add "公众号监控/每日报告/$DATE.md"
git commit -m "🏥 健康医疗公众号监控 - $DATE" 2>/dev/null
git push

echo "✅ 已同步到 GitHub"

# 生成通知
mkdir -p /tmp/notify
cat > /tmp/notify/health-accounts-monitor.txt <<EOF
🏥 健康医疗公众号监控完成

📊 今日统计：
- 监控公众号：${#ACCOUNTS[@]} 个
- 发现文章：$total_articles 篇

📱 公众号列表：
丁香医生、丁香园、丁香妈妈、丁香生活研究
鹤立烟雨、文小叔说、温暖中医
粤卫平台、drpei、约苗

📋 报告位置：obsidian-vault/公众号监控/每日报告/$DATE.md
EOF

echo ""
echo "========================================"
echo "✅ 健康医疗公众号监控完成！"
echo ""
echo "📋 查看报告："
echo "  cat $REPORT_FILE"
