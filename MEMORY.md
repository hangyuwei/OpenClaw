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
