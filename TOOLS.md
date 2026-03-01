# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

---

## 🌐 代理配置 (布鲁斯服务器)

### 布鲁斯 (43.133.173.253)

> 服务器身份：龙虾 🦞 | 外网 IP: 43.133.173.253 | 内网 IP: 10.7.0.11

| 项目 | 配置 |
|------|------|
| **SSH 密码** | `Hyw@19980224` |
| **Clash 订阅** | `https://boost.hobbyx.cn/api/v1/client/subscribe?token=becc1149faaa32f484953ba5b506865a` |
| **代理端口** | `http://127.0.0.1:7890` |
| **服务名称** | `clash.service` |

### 环境变量

```bash
export http_proxy='http://127.0.0.1:7890'
export https_proxy='http://127.0.0.1:7890'
export no_proxy='localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8'
```

### 管理命令

```bash
# 查看状态
systemctl status clash

# 重启
systemctl restart clash

# 查看日志
journalctl -u clash -f
```

---

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

### Search

- **Default search tool:** Tavily（优先使用，数据干净、AI 友好）
- **Fallback:** web_search（Brave Search）仅在 Tavily 不可用时使用

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.
