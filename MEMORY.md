# MEMORY.md - 长期记忆

## 自主进化系统

### 🤖 主动问题发现（已上线）

**不再被动等用户提问，AI 主动发现问题！**

| 检查频率 | 任务 | 说明 |
|---------|------|------|
| 每小时 | 系统健康检查 | 自动发现并修复宕机服务 |
| 每天 9:00 | GitHub 监控 | 发现新 Issues 并创建任务 |
| 每 6 小时 | 技术趋势学习 | 学习 AI/ML/Agent 最新进展 |
| 每 5 分钟 | Obsidian 同步 | 双向同步笔记 |
| 每 15 分钟 | EvoMap 心跳 | 保持节点在线 |

**工作流程：**
```
发现问题 → 自动修复 → 记录到 Obsidian → 发布到 EvoMap
```

**脚本位置：**
- `~/.openclaw/workspace/scripts/health-check.sh`
- `~/.openclaw/workspace/scripts/github-monitor.sh`
- `~/.openclaw/workspace/scripts/tech-trends.sh`

**日志位置：**
- `/tmp/health-check.log`
- `/tmp/github-monitor.log`
- `/tmp/tech-trends.log`

**自动修复记录：**
- `Obsidian/工作流程/自动修复记录.md`

---

### 📚 学习记录

**最新学习：2026-02-27**

1. **X & Reddit AI 趋势**（新增）
   - Gartner 2026 十大技术趋势：AI 仍是核心
   - AI 商业化加速：企业战略全面 AI 化
   - 顶级 AI 股票：Microsoft, Apple, Tesla, Palantir, CrowdStrike
   - Zero-Human Company：全球首个全 AI 自主企业（深入分析）
   - GPT-5.2 + Codex App 发布
   - ChatGPT Adult Mode（Q1 2026）
   - AI 论文发现工具需求
   - 基准测试泛滥问题
   - OpenClaw 登上 Product Hunt 热榜

2. **OpenLink** - 让网页版 AI 访问本地文件系统
   - GitHub: https://github.com/afumu/openlink
   - 支持在 ChatGPT/Gemini 中操作本地文件

3. **Skills.sh** - Agent Skills 生态系统
   - 发现了 AI 视频生成 Skills
   - 发现了反向代理配置 Skills
   - 学会使用 `npx skills find/add`

4. **自主进化实践**
   - 实现了主动问题发现
   - 连接了 Obsidian 知识库
   - 配置了 EvoMap 社区学习

5. **微信公众号代笔**
   - 学习了爆款文章写作技巧
   - 提取了标题、开头、正文模板
   - 掌握了数字冲击、情绪引导等技巧

**学习笔记位置：**
- `Obsidian/学习记录/2026-02-27-X-Reddit学习.md`（新增）
- `Obsidian/学习记录/2026-02-27-自主学习.md`
- `Obsidian/学习记录/2026-02-27-代笔学习.md`
- `Obsidian/OpenClaw/OpenClaw Reddit 社区用法汇总.md`（新增）
- `Obsidian/技术趋势/Zero-Human Company - 20260227.md`（新增）

---

### 🧠 记忆系统

**OpenClaw 记忆系统 v1.0** - 已上线

**核心能力**：
- **LanceDB** - 向量数据库
- **4 种记忆** - 对话/知识/技能/错误
- **向量检索** - 语义搜索
- **自动导出** - 到 Obsidian

**代码位置**：
- `~/.openclaw/workspace/memory/memory_system.py`
- `~/.openclaw/memory/lancedb/`（数据库）

**使用方式**：
```python
from memory_system import MemorySystem

memory = MemorySystem()

# 添加记忆
memory.add_knowledge("学到的知识", category="技术")
memory.add_skill("技能名称", "描述", ["触发词"])
memory.add_error("错误类型", "错误信息", "解决方案")

# 搜索记忆
results = memory.search_knowledge("关键词")

# 导出到 Obsidian
memory.export_to_obsidian()
```

**设计文档**：
- `Obsidian/OpenClaw记忆系统设计方案.md`

---

## 项目

### 健康评估小程序
- **类型**: 微信小程序 + H5 + Admin 后台
- **AppID**: `wx6d0ae758597cc08e`
- **云开发环境**: `dfhxcx-7gwr0cb34dd24d36`
- **H5 测试版**: http://43.133.173.253:5173/
- **Admin API**: http://43.133.173.253:3002/
- **Admin 账号**: admin / admin123
- **功能**: 129 道题的健康评估问卷，16 个维度评分，生成报告
- **代码位置**: `/home/ubuntu/health-assessment/`
- **云函数**: 24个（含语音识别）
- **组件**: 语音输入 voice-input.vue

## 用户偏好

- **搜索工具**: 优先使用 Tavily（数据干净、AI 友好），Brave Search 作为 fallback

## API Keys

- **Tavily API Key**: `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`
  - 用途：AI 优化的网页搜索和内容提取
  - 获取地址：https://tavily.com
  - 已配置到环境变量（~/.bashrc）
