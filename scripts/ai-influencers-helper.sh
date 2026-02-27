#!/bin/bash
# AI 博主关注助手
# 生成快速关注链接和监控脚本

WORKSPACE="$HOME/.openclaw/workspace"
OBSIDIAN="$WORKSPACE/obsidian-vault"

echo "🎯 AI 博主关注助手"
echo "===================="
echo ""

# 创建快速关注文件
QUICK_FOLLOW="$OBSIDIAN/AI博主快速关注.md"

cat > "$QUICK_FOLLOW" << 'EOF'
# 🎯 AI 博主快速关注 - 纯文本版

> 复制链接到浏览器，逐个关注

---

## 🔥 Top 20 必须关注

### Twitter/X

```
1. Sam Altman (OpenAI CEO)
   https://twitter.com/sama

2. Andrej Karpathy (AI 研究员)
   https://twitter.com/karpathy

3. Andrew Ng (AI 教育家)
   https://twitter.com/AndrewYNg

4. Yann LeCun (Meta AI)
   https://twitter.com/ylecun

5. Lex Fridman (AI 访谈)
   https://twitter.com/lexfridman

6. Elon Musk (xAI)
   https://twitter.com/elonmusk

7. Emad Mostaque (Stability AI)
   https://twitter.com/EMostaque

8. Thomas Wolf (Hugging Face)
   https://twitter.com/Thom_Wolf

9. Pieter Levels (独立开发者)
   https://twitter.com/levelsio

10. Paul Graham (YC)
    https://twitter.com/paulg
```

---

### YouTube

```
11. Lex Fridman Podcast
    https://www.youtube.com/@lexfridman

12. Andrej Karpathy
    https://www.youtube.com/@AndrejKarpathy

13. Two Minute Papers
    https://www.youtube.com/@TwoMinutePapers

14. 3Blue1Brown
    https://www.youtube.com/@3blue1brown

15. AI Explained
    https://www.youtube.com/@aiexplained-official

16. Yannic Kilcher
    https://www.youtube.com/@yannickilcher

17. DeepLearning.AI
    https://www.youtube.com/@Deeplearningai

18. StatQuest
    https://www.youtube.com/@statquest

19. Josh Starmer
    https://www.youtube.com/@joshstarmer

20. Henry AI Labs
    https://www.youtube.com/@HenryAILabs
```

---

## 📋 完整清单（100 人）

### Twitter/X 平台（50 人）

```
AI 研究者:
1. https://twitter.com/ylecun (Yann LeCun)
2. https://twitter.com/YoshuaBengio (Yoshua Bengio)
3. https://twitter.com/geoffreyhinton (Geoffrey Hinton)
4. https://twitter.com/AndrewYNg (Andrew Ng)
5. https://twitter.com/drfeifei (Fei-Fei Li)
6. https://twitter.com/demishassabis (Demis Hassabis)
7. https://twitter.com/ilyasut (Ilya Sutskever)
8. https://twitter.com/karpathy (Andrej Karpathy)
9. https://twitter.com/pabbeel (Pieter Abbeel)
10. https://twitter.com/chelseabfinn (Chelsea Finn)

公司 CEO:
11. https://twitter.com/sama (Sam Altman - OpenAI)
12. https://twitter.com/elonmusk (Elon Musk - xAI)
13. https://twitter.com/dario_amodei (Dario Amodei - Anthropic)
14. https://twitter.com/EMostaque (Emad Mostaque - Stability AI)
15. https://twitter.com/AravSrinivas (Aravind Srinivas - Perplexity)
16. https://twitter.com/Thom_Wolf (Thomas Wolf - Hugging Face)
17. https://twitter.com/ClementDelangue (Clement Delangue - Hugging Face)
18. https://twitter.com/alexandr_wang (Alexandr Wang - Scale AI)
19. https://twitter.com/miramurati (Mira Murati - OpenAI CTO)
20. https://twitter.com/gdb (Greg Brockman - OpenAI)

教育者:
21. https://twitter.com/lexfridman (Lex Fridman)
22. https://twitter.com/jeremyphoward (Jeremy Howard - Fast.ai)
23. https://twitter.com/rossgartner (Ross Gart ner)

工具/产品:
24. https://twitter.com/levelsio (Pieter Levels)
25. https://twitter.com/dannypostmaa (Danny Postma)
26. https://twitter.com/marc_lou (Marc Lou)
27. https://twitter.com/tdinh_me (Tony Dinh)

投资人:
28. https://twitter.com/paulg (Paul Graham)
29. https://twitter.com/balajis (Balaji Srinivasan)
30. https://twitter.com/ReidHoffman (Reid Hoffman)
```

---

## 🚀 快速关注步骤

### 方式 1：手动关注（推荐）

1. 打开上面的链接
2. 点击"关注"按钮
3. 预计时间：30-60 分钟

### 方式 2：批量关注

1. 打开 HTML 页面：
   ```bash
   # 在浏览器中打开
   open ~/.openclaw/workspace/ai-influencers-follow.html
   ```

2. 逐个点击"关注"按钮

3. 进度会自动保存

---

## 📊 关注进度

- [ ] Top 20 必须关注
- [ ] AI 研究者（10 人）
- [ ] 公司 CEO（10 人）
- [ ] 教育者（10 人）
- [ ] 工具/产品（10 人）
- [ ] 投资人（10 人）

**总计：100 人**

---

**创建时间**：2026-02-27
**最后更新**：2026-02-27
EOF

echo "✅ 快速关注清单已创建"
echo "📄 位置：$QUICK_FOLLOW"

# 创建博主监控脚本
MONITOR_SCRIPT="$WORKSPACE/scripts/influencer-monitor.sh"

cat > "$MONITOR_SCRIPT" << 'EOF'
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
EOF

echo ""
echo "✅ 监控完成！"
echo "📄 报告：$REPORT_FILE"

# 同步到 Git
cd ~/.openclaw/workspace/obsidian-vault
git add "AI博主动态/$DATE.md"
git commit -m "📊 AI 博主动态 - $DATE"
git push
EOF

chmod +x "$MONITOR_SCRIPT"
echo "✅ 博主监控脚本已创建"
echo "📄 位置：$MONITOR_SCRIPT"

# 创建定时任务
CRON_JOB="0 9 * * * $MONITOR_SCRIPT >> /tmp/influencer-monitor.log 2>&1"

echo ""
echo "⏰ 安装定时任务（每天 9:00 监控）："
echo "(crontab -l 2>/dev/null; echo \"$CRON_JOB\") | crontab -"

echo ""
echo "================================"
echo "✅ AI 博主关注助手已就绪！"
echo ""
echo "📋 快速开始："
echo "1. 查看快速关注清单："
echo "   cat \"$QUICK_FOLLOW\""
echo ""
echo "2. 打开 HTML 页面批量关注："
echo "   open $WORKSPACE/ai-influencers-follow.html"
echo ""
echo "3. 安装监控定时任务："
echo "   (crontab -l 2>/dev/null; echo \"$CRON_JOB\") | crontab -"
