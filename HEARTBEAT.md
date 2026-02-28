# HEARTBEAT.md

# 🧠 自主进化系统 v2.0

## 主动问题发现（已上线）

**不再被动等用户提问，我主动发现并解决问题！**

### 定时任务

| 频率 | 任务 | 动作 | 通知 |
|------|------|------|------|
| 每 10 分钟 | 系统健康检查 | 自动修复宕机服务 | 异常时通知 |
| 每天 4:00 | Obsidian 整理 | 分析 + 实际执行优化 | ✅ 通知 |
| 每天 7:00 | AI 学习监控 | 监控最新 AI/ML | ✅ 通知 |
| **每天 8:00** | **健康公众号监控** | **监控 10 个健康医疗公众号** | **✅ 通知** |
| 每天 9:00 | AI 视频监控 | 成本分析 + ROI | ✅ 通知 |
| 每天 9:00 | AI 健康区块链 | 行业动态 | ✅ 通知 |
| 每天 9:00 | AI 大健康生态 | 老龄化 + AI 医疗 | ✅ 通知 |
| 每 30 分钟 | Tamara 运营 | 系统状态检查 | 异常时通知 |
| 每 6 小时 | 深度学习 | AI 趋势 + 技术巨头 | ✅ 通知 |
| 每 5 分钟 | Obsidian 同步 | Git 自动提交推送 | 无 |

---

## 🔔 Heartbeat 检查清单

**每次 heartbeat 必须检查：**

1. **通知目录** - `/tmp/notify/*.txt`
   - 有通知文件 → 读取内容 → 发送给用户 → 删除文件
   - 这是**强制要求**，不能遗漏

2. **系统健康** - 内存、负载、磁盘

3. **定时任务状态** - cron 任务是否正常

---

## 通知机制

### 所有定时任务的通知格式

```
任务名称 + 标题

📊 分析结果/执行摘要

📋 详细报告位置
```

### 通知文件位置

- `/tmp/notify/obsidian-refine.txt` - Obsidian 整理
- `/tmp/notify/ai-learning-monitor.txt` - AI 学习监控
- `/tmp/notify/health-accounts-monitor.txt` - 健康公众号监控
- `/tmp/notify/ai-video-monitor.txt` - AI 视频监控
- `/tmp/notify/ai-health-blockchain.txt` - AI 健康区块链
- `/tmp/notify/ai-health-ecosystem.txt` - AI 大健康生态
- `/tmp/notify/learner-trends.txt` - 深度学习
- `/tmp/notify/health-check.txt` - 系统健康（仅异常时）

---

## 被动问题处理

当用户提问时：

1. **先搜索 Obsidian** - 看内部知识库
2. **再搜索 EvoMap** - 看社区智慧
3. **找不到就解决** - 然后双向发布

## 流程

```
主动发现 OR 被动提问
       ↓
    搜索知识
       ↓
    找到了？
    ↓       ↓
   是       否
    ↓       ↓
  应用    解决问题
           ↓
     写入 Obsidian
           ↓
    值得分享？
    ↓       ↓
   是       否
    ↓       ↓
发布EvoMap  仅记录
```

## EvoMap Skills

- `evomap-fetch-capsule` - 搜索解决方案
- `evomap-publish-capsule` - 发布解决方案
- `evomap-verify-report` - 验证报告
- `evomap-check-earnings` - 查看收益

## 节点信息

- Node ID: `node_41349a7fe0f7c472`
- Claim Code: EHYD-NUV4

---

## 知识库

- **Obsidian**: https://github.com/hangyuwei/Obsidian
- **本地路径**: `~/.openclaw/workspace/obsidian-vault`
- **同步频率**: 每 5 分钟

---

🦞 真正的自主进化：发现问题 → 学习 → 改进 → 分享
