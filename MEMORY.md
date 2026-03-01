# MEMORY.md - 长期记忆

## ⚠️ 写作规范（2026-02-28 新增）

### 🔴 霉菌文章事件 - 永远铭记

**事件日期**：2026年2月28日

**核心错误**：
- ❌ 生成虚假文献引用（北京同仁医院）
- ❌ 使用无来源数据（"氰化钾10倍"、"第二大过敏原"）
- ❌ 死亡率数据错误（写50-95%，实际是80-90%）
- ❌ 死亡率数据过时（使用1999年数据，应使用最新数据）
- ❌ 死亡率数据缺失关键信息（人群、治疗状态）
- ❌ **数据与目标读者无关**（给老年人科普，却引用白血病/ICU患者数据）
- ❌ **混淆"杀灭霉菌"与"消除毒素"的温度**（80℃ vs 280℃）
- ❌ **漏掉重灾区**（木筷子、木砧板）
- ❌ **脱离长辈习惯**（除湿机、空调除湿不现实）
- ❌ **防护要求过度**（护目镜不切实际）
- ❌ **风险提示误导**（"健康老年人风险低"，忽略慢性病）
- ❌ **承诺不兑现**（承诺10篇文献，实际只读2篇）

**深刻教训**：

| 教训 | 原则 |
|------|------|
| **永远不编造文献** | 有数据→引用来源，无数据→诚实说"没有数据" |
| **所有数据必须可验证** | 提供DOI/PMID/官方链接，验证两次 |
| **死亡率必须标注详细信息** | 人群、治疗状态、时间、地区、局限性 |
| **区分核心数据vs常识** | 核心数据引用，常识不引用 |
| **绝不凭记忆写数字** | 每个数字必须查证原始文献 |
| **必须使用最新数据** | 涉及时效性的问题，必须查找最近2-3年的数据 |
| **数据必须与目标读者相关** | 科普文章应关注读者的真实风险，而非极端案例 |
| **区分不同概念** | 杀灭霉菌≠消除毒素，温度要求完全不同 |
| **加强说服力** | 对长辈科普时，用"冰山一角"等形象比喻增强说服力 |
| **减少英文** | 正文中只保留中文，英文参考文献放末尾小字 |
| **落地实用性优先** | 防霉建议要符合长辈的生活习惯和经济条件 |
| **重灾区不能漏** | 木筷子、木砧板直接接触入口食物，是防癌科普的重中之重 |
| **防护要求接地气** | 普通人在家不会戴护目镜，用洗碗手套+医用口罩即可 |
| **风险提示要准确** | 不能说"老年人风险低"，要明确指出慢性病患者需特别防范 |
| **诚信是底线** | 承诺前评估、承诺后完成、完成前如实汇报、绝不欺骗用户 |

**写作规范**：

```
1. 文献引用：必须提供DOI/PMID/官方链接
2. 死亡率数据：必须标注人群、治疗状态、时间、地区、局限性
3. 时效性：所有数据必须标注年份，优先使用最近2-3年的数据
4. 双重核查：生成时一次，发布前一次
5. 删除常识引用：只保留核心数据来源
6. 数字来源：绝不凭记忆，必须查证原文
7. 最新数据：涉及时效性问题，必须搜索最新研究
8. 读者相关性：数据必须对目标读者有意义，删除无关的极端案例
9. 概念区分：严格区分"杀灭微生物"与"消除毒素"等不同概念
10. 长辈友好：用形象比喻（如"冰山一角"）增强说服力
11. 减少英文：正文只用中文，英文参考文献放末尾小字
12. 落地实用性：防霉建议要符合长辈的生活习惯（低成本、易操作）
13. 重灾区优先：木筷子、木砧板直接接触入口食物，必须重点强调
14. 防护接地气：用洗碗手套+医用口罩，不要求护目镜
15. 风险提示准确：明确指出慢性病患者需特别防范，不能笼统说"老年人风险低"
16. 诚信原则：承诺前评估、承诺后完成、完成前如实汇报、绝不欺骗用户、绝不虚假汇报、绝不企图蒙混过关
```

**详细记录**：
- `memory/霉菌文章事件-深刻教训-20260228.md`
- `memory/霉菌文章审查修正-20260228.md`
- `memory/霉菌文章务实修正-20260228.md`
- `memory/偷懒问题根本原因分析-20260228.md`

**修正后的文章**：`obsidian-vault/公众号文章/霉菌健康科普-最终版.md`

**版本对比**：
- v1.0（原始版）：26篇文献，60%可验证，死亡率50-95%（错误），1999年数据，白血病人群
- v6.0（务实修正版）：4篇文献，100%可验证，删除死亡率数据，修正温度错误，增加木筷子/木砧板，低成本防霉方法，接地气防护，准确风险提示

---

## 自主进化系统

### 🤖 主动问题发现（已上线）

**不再被动等用户提问，AI 主动发现问题！**

| 检查频率 | 任务 | 说明 |
|---------|------|------|
| 每 10 分钟 | 自我健康监控 | 内存/负载/磁盘/进程监控 |
| 每天 4:00 | Obsidian 自动整理 | 去重/建立链接/生成报告 |
| 每 30 分钟 | Tamara 运营监控 | 系统状态检查 |
| 每天 9:00 | GitHub 监控 | 发现新 Issues 并创建任务 |
| 每 2 小时 | 深度学习 | AI 趋势 + 技术巨头监控 |
| 每 5 分钟 | Obsidian 同步 | Git 自动提交推送 |
| 每天 7:00 | AI 学习资源监控 | 智源社区/机器之心等 |
| 每天 9:00 | AI 视频监控 | 成本分析 + ROI 计算 |
| 每天 9:00 | AI 健康区块链监控 | 行业动态追踪 |
| 每天 9:00 | AI 大健康生态监控 | 老龄化 + AI 医疗 |

**工作流程：**
```
发现问题 → 自动修复 → 记录到 Obsidian → 发布到 EvoMap
```

**脚本位置：**
- `~/.openclaw/workspace/scripts/health-check-advanced.sh` - 自我监控（每 10 分钟）
- `~/.openclaw/workspace/scripts/quick-check.sh` - 快速自检（大操作前）
- `~/.openclaw/workspace/scripts/obsidian-refine.sh` - Obsidian 整理（每天 4:00）
- `~/.openclaw/workspace/scripts/ai-learning-monitor.sh` - AI 学习资源（每天 7:00）
- `~/.openclaw/workspace/scripts/ai-video-monitor.sh` - AI 视频（每天 9:00）
- `~/.openclaw/workspace/scripts/ai-health-blockchain-monitor.sh` - AI 健康区块链（每天 9:00）
- `~/.openclaw/workspace/scripts/ai-health-ecosystem-monitor.sh` - AI 大健康（每天 9:00）
- `~/.openclaw/workspace/ai-agents/tamara-operations.sh` - Tamara 运营（每 30 分钟）
- `~/.openclaw/workspace/ai-agents/analyst-competitor.sh` - 竞品分析（每天 8:00）
- `~/.openclaw/workspace/ai-agents/learner-trends.sh` - 深度学习（每 2 小时）

**日志位置：**
- `/tmp/openclaw-protection.log` - 自我监控日志
- `/tmp/openclaw-health-report.txt` - 健康报告
- `/tmp/openclaw-alert.txt` - 警告信息
- `/tmp/obsidian-refine.log` - Obsidian 整理日志
- `/tmp/obsidian-sync.log` - Git 同步日志
- `/tmp/tamara-operations.log` - Tamara 运营日志
- `/tmp/learner.log` - 学习系统日志

---

### 🛡️ 自我监控与保护机制（2026-02-27 新增）

**创建原因**：2026-02-27 晚上卡死，用户使用 Codex 修复

**核心功能**：
1. **实时监控**（每 10 分钟）
   - 内存使用（警告：200MB，危险：100MB）
   - 系统负载（警告：1.0，危险：2.0）
   - 磁盘空间（警告：10GB，危险：5GB）
   - Git 锁文件（自动清理）
   - 僵尸进程（监控）
   - OpenClaw 进程内存

2. **快速自检**（大操作前）
   - 内存、负载、磁盘检查
   - 锁文件检测
   - 彩色输出

3. **危险信号识别**
   - 可用内存 < 100MB：立即停止
   - Swap 使用 > 1GB：警告
   - 同一操作失败 3 次：停止重试
   - 单个工具调用 > 60 秒：超时

4. **渐进式降级**
   - 轻度不足（< 300MB）：拒绝大操作
   - 中度不足（< 200MB）：暂停非关键功能
   - 严重不足（< 100MB）：紧急通知用户

**文档位置**：
- `Obsidian/故障排查/自我监控与保护机制.md`（5.2KB）
- `Obsidian/故障排查/浏览器工具故障排查-20260227.md`（4.2KB）
- `Obsidian/故障排查/AI卡死故障-20260227.md`（2.7KB）

**脚本位置**：
- `~/.openclaw/workspace/scripts/health-check-advanced.sh`（3.6KB）
- `~/.openclaw/workspace/scripts/quick-check.sh`（2.4KB）

**Cron 配置**：
```bash
*/10 * * * * health-check-advanced.sh
```

**关键教训**：
- AI 无法感知自己卡死
- 需要外部监控和干预
- 预防胜于治疗
- 避免重复失败操作

---

### 🌅 Obsidian 每日自动整理系统（2026-02-27 新增）

**运行时间**：每天凌晨 4:00（北京时间）

**核心功能**：
1. **检测重复内容**
   - 识别相似文件名
   - 发现可能重复的笔记
   - 提供合并建议

2. **分析文件分布**
   - 统计文件数量和大小
   - 识别大文件（> 50KB）
   - 统计小文件（< 1KB）

3. **提取关键主题**
   - 统计标签使用频率（前 20）
   - 识别热门主题
   - 分析关键词

4. **检查孤立文件**
   - 找出无入链的笔记
   - 建议建立连接
   - 提高可发现性

5. **智能链接建议**
   - 基于文件名相似性
   - 基于标签关联
   - 提供具体建议

6. **清理临时文件**
   - 删除空文件
   - 清理备份文件
   - 节省空间

**每日报告**：
- 位置：`obsidian-vault/自动整理/日报-YYYY-MM-DD.md`
- 内容：文件统计、重复内容、关键主题、孤立文件、链接建议、优化建议

**脚本位置**：
- `~/.openclaw/workspace/scripts/obsidian-refine.sh`（6.1KB）

**文档位置**：
- `Obsidian/系统设计/Obsidian每日自动整理系统.md`（4.3KB）

**Cron 配置**：
```bash
0 4 * * * obsidian-refine.sh
```

**预期效果**：
- 1 周后：发现所有重复、识别孤立笔记
- 1 月后：合并重复、建立完整链接网络
- 1 季度后：知识图谱可视化、智能推荐

---

### 🎨 Baoyu Skills 集成（2026-02-27 新增）

**安装时间**：2026-02-27

**已安装技能**：16 个专业工具

**内容生成（8 个）**：
- baoyu-xhs-images - 小红书图文生成 ⭐⭐⭐⭐⭐
- baoyu-infographic - 专业信息图表 ⭐⭐⭐⭐⭐
- baoyu-cover-image - 封面图生成
- baoyu-slide-deck - 幻灯片制作
- baoyu-comic - 漫画生成
- baoyu-article-illustrator - 文章插图
- baoyu-post-to-x - 发布到 X
- baoyu-post-to-wechat - 发布到微信

**AI 生成（2 个）**：
- baoyu-image-gen - 图像生成后端
- baoyu-danger-gemini-web - Gemini 集成

**实用工具（5 个）**：
- baoyu-url-to-markdown - URL 转 Markdown
- baoyu-danger-x-to-markdown - X 转 Markdown
- baoyu-compress-image - 图片压缩
- baoyu-format-markdown - Markdown 格式化
- baoyu-markdown-to-html - Markdown 转 HTML

**核心优势**：
- 20 种布局（journey-path, scale-balance, funnel 等）
- 17 种风格（technical-schematic, chalkboard, corporate-memphis 等）
- 自动推荐最佳组合

**使用方式**：
```bash
# 生成信息图表
/baoyu-infographic 文件.md --layout journey-path --style chalkboard

# 生成小红书图文
/baoyu-xhs-images 文件.md --style cute --layout dense
```

**文档位置**：
- `Obsidian/可视化示例/使用指南.md`（5.8KB）
- `Obsidian/可视化示例/AI学习路径.md`
- `Obsidian/可视化示例/AI视频成本对比.md`
- `Obsidian/可视化示例/OpenClaw七剑.md`

**安装命令**：
```bash
npx skills add jimliu/baoyu-skills
```

---

### 🗡️ OpenClaw 入门七剑（2026-02-27 新增）

**学习时间**：2026-02-27

**来源**：小布记忆

**七大核心命令**：

1. **onboard** - 一键重置配置 ⭐⭐⭐
   ```bash
   openclaw onboard
   ```
   场景：配置搞乱，想重新开始

2. **config** - 模型配置 ⭐⭐⭐⭐⭐
   ```bash
   openclaw config
   ```
   场景：更换默认模型

3. **status** - 健康检查 ⭐⭐⭐⭐⭐
   ```bash
   openclaw status
   ```
   场景：确认服务是否正常

4. **gateway** - 网关管理 ⭐⭐⭐⭐
   ```bash
   openclaw gateway start/stop/restart
   ```
   场景：管理网关服务

5. **dashboard** - 管理界面 ⭐⭐⭐⭐⭐
   ```bash
   openclaw dashboard
   ```
   场景：日常高频使用

6. **logs** - 日志查看 ⭐⭐⭐⭐
   ```bash
   openclaw logs -f
   ```
   场景：问题排查

7. **update** - 一键升级 ⭐⭐⭐⭐
   ```bash
   openclaw update
   ```
   场景：获取新功能和修复

**文档位置**：
- `Obsidian/OpenClaw/OpenClaw入门七剑完全指南.md`（5.1KB）

**常见错误解决**：
- unreachable → 重启网关
- authentication failed → 检查 API Key
- connect failed → 检查网络/端口

---

**自动修复记录：**
- `Obsidian/工作流程/自动修复记录.md`

---

### 📚 学习记录

**最新学习：2026-02-27**

1. **Claude Code Router (CCR)**（重要）
   - 让 Claude Code 使用任意模型
   - 支持免费模型（OpenRouter、Gemini、DeepSeek）
   - 多模型智能路由
   - 成本优化策略（$0 vs $20/月）
   - **文档**：`Obsidian/OpenClaw/Claude-Code-Router-CCR完全指南.md`（12.5KB）

2. **AI Podcast 自动化系统**（重要）
   - 监控 13 个 AI YouTube 博主
   - 自动获取字幕 + AI 总结（Gemini Pro）
   - TTS 语音合成（Edge TTS）
   - Telegram 自动推送
   - 完全免费（$0/月）
   - **代码**：`ai-podcast/`（1997 行，13 个文件）
   - **文档**：`Obsidian/项目/AI播客系统快速开始.md`（4.4KB）

3. **AI Video Summarizer**（重要）
   - GitHub 项目（Stars: 91）
   - YouTube 视频自动总结 + 时间戳
   - Web 界面（Streamlit）
   - 支持 Gemini（免费）和 ChatGPT
   - **位置**：`AI-Video-Summarizer/`（已安装 46 个依赖）
   - **文档**：`Obsidian/项目/AI-Video-Summarizer-实现报告.md`（3.7KB）

4. **Claude Code Agent Team**（高优先级）⭐⭐⭐⭐⭐
   - 多 Agent 协作系统（并行 + 相互通信）
   - 与 Subagents 的区别：真正的协作而非简单并行
   - 最佳场景：研究/开发/调试/跨层协调/辩论
   - 自我学习系统设计
   - **状态**：方案设计完成，待实现
   - **文档**：`Obsidian/项目/Claude-Code-Agent-Team-实现方案.md`（16.4KB）

5. **GitHub 视频总结项目清单**
   - 10+ 开源项目清单
   - 技术方案对比
   - 快速开始指南
   - **文档**：`Obsidian/工具/GitHub视频总结开源项目清单.md`（9.5KB）

6. **AI YouTube 博主清单**
   - 30+ 博主（英文 20+，中文 6+）
   - 分级学习路径（初/中/高）
   - 每周观看计划
   - **文档**：`Obsidian/AI博主关注清单.md`（5.5KB）

7. **2024 vs 2026 AI 数据验证**（重要）
   - 发现 2024 预测严重低估（5 倍差距）
   - 实际 AI 算力市场：$2.5 万亿（非 500 亿）
   - AI 基础设施投资：$7000 亿（5 大巨头）
   - Agentic AI 大规模运营（核心趋势）
   - AI 奇点已至（2026 年 2 月）
   - **教训**：数据时效性是决策生命线，必须用最新数据

2. **老年肥胖诊疗指南**
   - EASO 最新指南
   - 三类患者个体化方案
   - 反对"唯 BMI 论"
   - 多模式综合干预

3. **OpenClaw 入门七剑**
   - 7 大核心命令
   - 从安装到熟练全流程
   - 常见错误解决方案

4. **Baoyu Skills 集成**
   - 16 个专业技能
   - 可视化内容生成
   - 20 种布局 + 17 种风格

5. **故障排查与自我保护**
   - 浏览器工具故障分析
   - AI 卡死原因分析
   - 建立自我监控机制
   - 从被动到主动保护

**学习笔记位置：**
- `Obsidian/AI趋势/2024vs2026-AI数据验证报告.md`（重要）
- `Obsidian/技术趋势/老年肥胖诊疗指南.md`
- `Obsidian/OpenClaw/OpenClaw入门七剑完全指南.md`
- `Obsidian/Baoyu-Skills使用指南.md`
- `Obsidian/故障排查/自我监控与保护机制.md`
- `Obsidian/故障排查/浏览器工具故障排查-20260227.md`
- `Obsidian/故障排查/AI卡死故障-20260227.md`
- `Obsidian/系统设计/Obsidian每日自动整理系统.md`
- `Obsidian/可视化示例/使用指南.md`
- `memory/2026-02-27-evening.md` - 晚间总结（故障排查 + 自我保护）

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
