# 龙虾已安装的 Skills 清单

> 生成时间：2026-02-23

---

## 📦 工作区 Skills（用户安装）

**位置**: `~/.openclaw/workspace/skills/`

| Skill | 描述 | 状态 |
|-------|------|------|
| **github** | 使用 `gh` CLI 操作 GitHub（issues、PRs、CI） | ✅ |
| **gog** | Google Workspace CLI（Gmail、Calendar、Drive、Contacts、Sheets、Docs） | ✅ |
| **nano-banana-pro** | 图像生成/编辑（Gemini 3 Pro Image），支持文生图和图生图 | ✅ |
| **self-improving** | 自我改进代理，纠错即改进，记忆自我完善 | ✅ |
| **tavily-search** | AI 优化的网页搜索（Tavily API），返回简洁相关结果 | ✅ |
| **twitter** | 病毒式推文创作，基于热门案例和 X 算法优化 | ✅ |
| **sqlite** | SQLite 数据库操作，支持并发、WAL 模式、类型处理 | ✅ |
| **pg** | PostgreSQL 数据库操作，索引优化、查询模式、连接管理 | ✅ |
| **playwright** | 无头浏览器自动化，支持 Chromium/Firefox/WebKit | ✅ |
| **figma** | Figma 设计稿解析，提取颜色、间距、切图素材 | ✅ |

---

## 🛠️ 内置 Skills（OpenClaw Bundled）

**位置**: `/usr/lib/node_modules/openclaw/skills/`

### 🔧 开发工具
| Skill | 描述 |
|-------|------|
| **clawhub** | ClawHub CLI，搜索、安装、更新、发布 agent skills |
| **coding-agent** | 委托编码任务给 Codex、Claude Code 或 Pi agents |
| **gh-issues** | 获取 GitHub issues，实现修复并开 PR |
| **github** | 使用 `gh` CLI 操作 GitHub |
| **skill-creator** | 创建或更新 AgentSkills |

### 🤖 AI 模型
| Skill | 描述 |
|-------|------|
| **gemini** | Google Gemini API |
| **nano-banana-pro** | 图像生成/编辑 |
| **nano-pdf** | PDF 处理 |
| **openai-image-gen** | OpenAI 图像生成 |
| **openai-whisper** | OpenAI Whisper 语音识别（本地） |
| **openai-whisper-api** | OpenAI Whisper API（云端） |
| **sherpa-onnx-tts** | Sherpa ONNX 文本转语音 |

### 📝 笔记 & 任务
| Skill | 描述 |
|-------|------|
| **apple-notes** | Apple Notes 笔记 |
| **apple-reminders** | Apple 提醒事项 |
| **bear-notes** | Bear 笔记 |
| **notion** | Notion 集成 |
| **obsidian** | Obsidian 笔记 |
| **things-mac** | Things 3 任务管理 |
| **trello** | Trello 看板 |

### 💬 通讯
| Skill | 描述 |
|-------|------|
| **discord** | Discord 集成 |
| **slack** | Slack 集成 |
| **imsg** | iMessage |
| **himalaya** | 邮件客户端 |
| **wacli** | WhatsApp CLI |

### 🏠 智能家居
| Skill | 描述 |
|-------|------|
| **openhue** | Philips Hue 控制 |
| **sonoscli** | Sonos 音响控制 |
| **spotify-player** | Spotify 播放器 |

### 📷 多媒体
| Skill | 描述 |
|-------|------|
| **camsnap** | 摄像头快照 |
| **video-frames** | 视频帧提取 |
| **gifgrep** | GIF 搜索 |
| **songsee** | 歌曲识别 |

### 🔐 安全
| Skill | 描述 |
|-------|------|
| **1password** | 1Password 密码管理 |
| **healthcheck** | 主机安全加固和风险配置 |

### 🎯 其他工具
| Skill | 描述 |
|-------|------|
| **weather** | 天气查询（wttr.in / Open-Meteo） |
| **canvas** | Canvas 展示/操作 |
| **tmux** | 远程控制 tmux 会话 |
| **summarize** | 文本摘要 |
| **oracle** | Oracle 数据库 |
| **blucli** | 蓝牙 CLI |
| **peekaboo** | 屏幕共享 |
| **voice-call** | 语音通话 |
| **blogwatcher** | 博客监控 |
| **ordercli** | 订单 CLI |
| **goplaces** | 地点搜索 |
| **food-order** | 食物订购 |
| **mcporter** | Minecraft |
| **eightctl** | 8ctl 控制 |
| **model-usage** | 模型使用统计 |
| **session-logs** | 会话日志 |
| **bluebubbles** | BlueBubbles（iMessage 服务器） |

---

## 📊 统计

| 类别 | 数量 |
|------|------|
| 工作区 Skills | 10 |
| 内置 Skills | 52 |
| **总计** | **62** |

---

## 🔗 获取更多 Skills

访问 ClawHub: https://clawhub.com

```bash
# 搜索 skills
clawhub search <关键词>

# 安装 skill
clawhub install <skill-name>

# 列出已安装
clawhub list
```
