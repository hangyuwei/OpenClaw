# 🦞 龙虾的记忆仓库

> 这是 OpenClaw Agent 的持久化记忆存储。每次 `/new` 后会从这里恢复所有信息。

---

## 📁 文件结构

| 文件 | 用途 |
|------|------|
| `PROJECTS.md` | 所有项目信息（健康小程序、部署地址、账号密码等） |
| `SYSTEM.md` | 系统配置、已安装 Skills、工作流程 |
| `README.md` | 本文件，说明如何使用 |

---

## 🔄 工作流程

### /new 后恢复记忆
```bash
cd /home/ubuntu/.openclaw/workspace
git clone https://github.com/hangyuwei/OpenClaw.git memory-repo
# 或
cd memory-repo && git pull
```

然后读取：
1. `memory-repo/PROJECTS.md` - 项目信息
2. `memory-repo/SYSTEM.md` - 系统配置

### 更新记忆
```bash
cd /home/ubuntu/.openclaw/workspace/memory-repo
git add -A
git commit -m "更新记忆：xxx"
git push
```

---

## 📊 记忆内容

### 项目
- **健康评估小程序** - 微信小程序 + H5 + Admin
- 部署地址、账号、云函数等

### Skills（10个）
- tavily-search, github, gog, twitter, nano-banana-pro
- self-improving, sqlite, pg, playwright, figma

### 配置
- 搜索工具：Tavily（优先）
- 语言：中文
- 时区：Asia/Shanghai

---

## ⚠️ 重要

- **所有重要信息都必须保存到这里**
- **每次对话后要 git push**
- **/new 后要 git pull**

---

🦞 龙虾 @ OpenClaw
