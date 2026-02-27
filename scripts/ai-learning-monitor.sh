#!/bin/bash
# AI 硬核技术学习资源监控
# 每天自动抓取最新学习资源

WORKSPACE="$HOME/.openclaw/workspace"
OBSIDIAN="$WORKSPACE/obsidian-vault"
TAVILY_KEY="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"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

echo "🎓 AI 硬核技术学习监控 - $DATE $TIME"
echo "========================================"

# 创建输出目录
mkdir -p "$OBSIDIAN/学习资源监控"
mkdir -p "$OBSIDIAN/学习资源监控/每日报告"

export TAVILY_API_KEY="$TAVILY_KEY"

# ============================================
# 第一部分：国内中文社区监控
# ============================================

echo ""
echo "🔍 第一阶段：国内中文社区监控"
echo "--------------------------------"

# 1. 智源社区（BAAI）
echo "📚 智源社区..."
BAAI_NEWS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "\"智源社区\" BAAI 人工智能 最新报告 讲座 2026" \
  -n 5 \
  --topic news \
  --days 7 2>&1)

# 2. 机器之心
echo "🤖 机器之心..."
JQZC_NEWS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:jiqizhixin.com 人工智能 技术 论文 2026" \
  -n 8 \
  --topic news \
  --days 3 2>&1)

# 3. V2EX AI 节点
echo "💬 V2EX AI 节点..."
V2EX_AI=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:v2ex.com AI 人工智能 大模型 2026" \
  -n 5 \
  --topic news \
  --days 3 2>&1)

# 4. 掘金 AI
echo "⛏️ 掘金 AI..."
JUEJIN_AI=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:juejin.cn 人工智能 AI 技术 2026" \
  -n 5 \
  --topic news \
  --days 3 2>&1)

# ============================================
# 第二部分：国际模型社区监控
# ============================================

echo ""
echo "🌐 第二阶段：国际模型社区监控"
echo "--------------------------------"

# 5. Hugging Face Trending
echo "🤗 Hugging Face 热门模型..."
HF_MODELS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:huggingface.co trending models new release 2026" \
  -n 8 \
  --topic news \
  --days 7 2>&1)

# 6. GitHub AI Trending
echo "🐙 GitHub AI Trending..."
GITHUB_AI=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:github.com AI \"machine learning\" trending repository 2026" \
  -n 8 \
  --topic news \
  --days 7 2>&1)

# ============================================
# 第三部分：学术前沿监控
# ============================================

echo ""
echo "📖 第三阶段：学术前沿监控"
echo "--------------------------------"

# 7. arXiv 最新论文
echo "📄 arXiv 最新论文..."
ARXIV_PAPERS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:arxiv.org cs.AI cs.LG cs.CL 2026 latest" \
  -n 10 \
  --topic news \
  --days 3 2>&1)

# 8. Papers with Code
echo "📊 Papers with Code..."
PWC_PAPERS=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:paperswithcode.com latest papers AI 2026" \
  -n 8 \
  --topic news \
  --days 7 2>&1)

# ============================================
# 第四部分：国际社区监控
# ============================================

echo ""
echo "🌍 第四阶段：国际社区监控"
echo "--------------------------------"

# 9. Reddit r/LocalLLaMA
echo "🦙 Reddit LocalLLaMA..."
REDDIT_LLAMA=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:reddit.com/r/LocalLLaMA trending discussion 2026" \
  -n 8 \
  --topic news \
  --days 3 2>&1)

# 10. Reddit r/MachineLearning
echo "🧠 Reddit MachineLearning..."
REDDIT_ML=$(node ~/.openclaw/workspace/skills/tavily-search/scripts/search.mjs \
  "site:reddit.com/r/MachineLearning latest research 2026" \
  -n 8 \
  --topic news \
  --days 3 2>&1)

# ============================================
# 生成每日学习报告
# ============================================

REPORT_FILE="$OBSIDIAN/学习资源监控/每日报告/$DATE.md"

cat > "$REPORT_FILE" << EOF
# 🎓 AI 硬核技术学习资源 - $DATE

> 监控时间：$TIME
> 学习阶段：第 ? 天
> 今日任务：论文阅读 + 代码实践

---

## 📚 国内中文社区

### 1. 智源社区（BAAI）

$BAAI_NEWS

**今日任务**：
- [ ] 观看 1-2 个技术讲座
- [ ] 记录关键笔记

---

### 2. 机器之心

$JQZC_NEWS

**今日任务**：
- [ ] 深度阅读 2-3 篇文章
- [ ] 保存有价值内容

---

### 3. V2EX AI 节点

$V2EX_AI

**今日任务**：
- [ ] 参与讨论 1-2 次
- [ ] 学习他人经验

---

### 4. 掘金 AI

$JUEJIN_AI

**今日任务**：
- [ ] 浏览热门文章
- [ ] 收藏优质内容

---

## 🌐 国际模型社区

### 5. Hugging Face 热门模型

$HF_MODELS

**今日任务**：
- [ ] 探索 1-2 个新模型
- [ ] 阅读模型文档

---

### 6. GitHub AI Trending

$GITHUB_AI

**今日任务**：
- [ ] Star 1-2 个优质项目
- [ ] 阅读 README

---

## 📖 学术前沿

### 7. arXiv 最新论文

$ARXIV_PAPERS

**今日任务**：
- [ ] 浏览新论文标题
- [ ] 标记 2-3 篇感兴趣论文
- [ ] 深度阅读 1 篇

---

### 8. Papers with Code

$PWC_PAPERS

**今日任务**：
- [ ] 查看最新论文 + 代码
- [ ] 了解 SOTA 排行

---

## 🌍 国际社区

### 9. Reddit r/LocalLLaMA

$REDDIT_LLAMA

**今日任务**：
- [ ] 浏览热门讨论
- [ ] 学习本地部署经验

---

### 10. Reddit r/MachineLearning

$REDDIT_ML

**今日任务**：
- [ ] 参与讨论 1-2 次
- [ ] 关注研究动态

---

## 📊 今日学习计划

### 早晨（30 分钟）

- [ ] 浏览 arXiv 新论文（10 分钟）
- [ ] 阅读机器之心文章（15 分钟）
- [ ] 记录笔记（5 分钟）

---

### 午休（20 分钟）

- [ ] 浏览 V2EX/掘金（10 分钟）
- [ ] Hugging Face 探索（10 分钟）

---

### 晚上（60 分钟）

- [ ] 深度学习（论文/代码）（40 分钟）
- [ ] Reddit/GitHub（15 分钟）
- [ ] 总结笔记（5 分钟）

---

## 💡 学习建议

### 今日重点

**优先级 1**（必须完成）：
- [ ] 论文阅读：1 篇
- [ ] 笔记记录：3-5 条

**优先级 2**（尽量完成）：
- [ ] 代码实践：30 分钟
- [ ] 社区参与：1-2 次

**优先级 3**（可选）：
- [ ] 项目开发
- [ ] 博客写作

---

### 学习策略

**不要追求完美**：
- ❌ 试图理解所有细节
- ✅ 抓住核心思想即可

**持续输出**：
- ❌ 只看不记
- ✅ 记录笔记总结

**动手实践**：
- ❌ 只读论文
- ✅ 运行代码验证

---

## 📈 学习进度

### 本周目标

- [ ] 论文阅读：3-5 篇
- [ ] 代码实践：2-3 小时
- [ ] 笔记记录：10-15 条
- [ ] 社区参与：5-8 次

**当前进度**：
- 论文：0/5 篇
- 代码：0/3 小时
- 笔记：0/15 条
- 社区：0/8 次

---

### 本月目标

- [ ] 论文阅读：15-20 篇
- [ ] 项目实践：1-2 个
- [ ] 技术博客：1-2 篇
- [ ] 开源贡献：1-2 次

**当前进度**：
- 论文：0/20 篇
- 项目：0/2 个
- 博客：0/2 篇
- 贡献：0/2 次

---

## 🎯 重点推荐

### 今日必读（Top 3）

1. **论文推荐**
   - 标题：？
   - 原因：？
   - 链接：？

2. **项目推荐**
   - 名称：？
   - 原因：？
   - 链接：？

3. **讨论推荐**
   - 主题：？
   - 原因：？
   - 链接：？

---

### 本周必读

1. 论文：1-2 篇高质量论文
2. 项目：1 个开源项目深入研究
3. 讲座：1-2 个技术讲座

---

## ❓ 待解决问题

### 学习问题

1. ？
2. ？

### 技术问题

1. ？
2. ？

---

## 📝 学习笔记

### 今日笔记

（在这里记录学习笔记）

---

### 关键知识点

1. ？
2. ？
3. ？

---

## 🔗 快速链接

### 国内社区

- 智源社区：https://hub.baai.ac.cn/
- 机器之心：https://www.jiqizhixin.com/
- V2EX：https://www.v2ex.com/
- 掘金：https://juejin.cn/

---

### 国际社区

- Hugging Face：https://huggingface.co/
- GitHub：https://github.com/
- arXiv：https://arxiv.org/
- Papers with Code：https://paperswithcode.com/
- Reddit：https://www.reddit.com/

---

**自动生成**：OpenClaw 学习资源监控
**下次更新**：明天
EOF

echo "✅ 学习资源报告已生成：$REPORT_FILE"

# 同步到 Git
cd "$OBSIDIAN"
git add "学习资源监控/每日报告/$DATE.md"
git commit -m "🎓 AI 硬核技术学习资源 - $DATE"
git push

echo "✅ 已同步到 GitHub"

echo ""
echo "========================================"
echo "✅ AI 硬核技术学习监控完成！"
echo ""
echo "📋 本次监控："
echo "  - 国内社区：4 个"
echo "  - 国际社区：2 个"
echo "  - 学术资源：2 个"
echo "  - 论坛讨论：2 个"
echo ""
echo "📋 查看报告："
echo "  cat $REPORT_FILE"
