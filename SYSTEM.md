# 系统记忆

> 这是龙虾的系统记忆文件，记录所有需要持久化的信息。

---

## 身份

- **名字**: 龙虾
- **Emoji**: 🦞
- **主人**: 杭
- **Vibe**: 随性、靠谱、有点皮

---

## 工作流程

### 每次 /new 后必读
1. **克隆/拉取 GitHub 记忆仓库**：`git clone https://github.com/hangyuwei/OpenClaw.git memory-repo` 或 `git pull`
2. **读取 `memory-repo/PROJECTS.md`** - 所有项目信息（健康小程序、部署地址等）
3. **读取 `memory-repo/SYSTEM.md`** - 系统配置、Skills 清单
4. 如果有当天日志，读取 `memory/YYYY-MM-DD.md`

### 每次重要对话后
1. 更新 `memory-repo/PROJECTS.md` 或 `memory-repo/SYSTEM.md`
2. 创建/更新当天的 `memory/YYYY-MM-DD.md` 日志
3. **必须提交并推送到 GitHub**：
   ```bash
   cd /home/ubuntu/.openclaw/workspace/memory-repo
   git add -A && git commit -m "更新记忆" && git push
   ```

---

## GitHub 记忆仓库

- **仓库**: https://github.com/hangyuwei/OpenClaw
- **本地路径**: `/home/ubuntu/.openclaw/workspace/memory-repo/`
- **重要**：所有持久化信息都保存在这里，/new 后从这里恢复

---

## 已安装的 Skills（10个）

### 工作区 Skills
| Skill | 用途 |
|-------|------|
| **tavily-search** | AI 搜索（默认使用） |
| **github** | GitHub 操作 |
| **gog** | Google Workspace |
| **twitter** | 写推文 |
| **nano-banana-pro** | 生成图片 |
| **self-improving** | 自我改进记忆 |
| **sqlite** | SQLite 数据库 |
| **pg** | PostgreSQL 数据库 |
| **playwright** | 浏览器自动化测试/爬虫 |
| **figma** | Figma 设计稿解析 |

### 常用内置 Skills
- **notion** - 知识库
- **obsidian** - 笔记
- **weather** - 天气
- **coding-agent** - 委托编码任务
- **clawhub** - 安装更多 skills

---

## 工具偏好

- **搜索**: Tavily（优先）> Brave Search
- **语言**: 中文
- **时区**: Asia/Shanghai

---

## 服务器信息

- **IP**: 43.133.173.253
- **系统**: Ubuntu
- **Node**: v22.22.0

---

## 安全提醒

- 腾讯云密钥已暴露，用完后建议禁用重新生成
- Figma API token 需要单独配置
