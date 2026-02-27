# 🎙️ AI Podcast 自动化系统

每天早上自动生成 AI 技术播客，推送到 Telegram！

## 🎯 功能特点

- ✅ **全自动运行**：无需人工干预
- ✅ **监控 30+ AI 博主**：实时跟踪最新视频
- ✅ **智能过滤**：只处理高质量内容
- ✅ **AI 总结**：Gemini Pro 生成播客脚本
- ✅ **中文播客**：Edge TTS 生成高质量语音
- ✅ **定时推送**：每天早上 7:00 发送到 Telegram
- ✅ **成本为零**：使用免费工具

---

## 🚀 快速开始

### 步骤 1：安装依赖

```bash
cd ~/.openclaw/workspace/ai-podcast
pip install -r requirements.txt
```

---

### 步骤 2：配置 API Keys

编辑 `config.json`：

```json
{
  "api_keys": {
    "youtube_api_key": "YOUR_YOUTUBE_API_KEY",
    "gemini_api_key": "YOUR_GEMINI_API_KEY",
    "telegram_bot_token": "YOUR_BOT_TOKEN",
    "telegram_chat_id": "YOUR_CHAT_ID"
  }
}
```

**获取方法**：

1. **YouTube API Key**：
   - 访问：https://console.cloud.google.com/
   - 创建项目 → 启用 YouTube Data API v3
   - 创建凭据 → API Key

2. **Gemini API Key**：
   - 访问：https://makersuite.google.com/app/apikey
   - 点击 "Create API Key"
   - 复制 Key

3. **Telegram Bot**：
   - 找 @BotFather → /newbot → 获取 Token
   - 找 @userinfobot → 获取 Chat ID

---

### 步骤 3：测试单个视频

```bash
# 使用安格视界的 OpenClaw 视频测试
python main.py --single Zh9IscszDQg

# 或使用测试模式
python main.py --test
```

**预期输出**：
```
✅ 字幕获取成功
✅ 播客脚本生成成功
✅ 语音生成成功: audio/podcast_Zh9IscszDQg.mp3
```

---

### 步骤 4：检查新视频

```bash
# 仅检查，不生成播客
python main.py --check-only
```

---

### 步骤 5：运行完整流程

```bash
# 完整流程：检查 + 生成 + 发送
python main.py
```

---

## 📅 设置定时任务

### Cron 配置

```bash
crontab -e
```

添加以下内容：

```bash
# 每 2 小时检查新视频
0 */2 * * * cd /home/ubuntu/.openclaw/workspace/ai-podcast && /usr/bin/python3 main.py --check-only >> logs/check.log 2>&1

# 每天早上 6:00 生成播客
0 6 * * * cd /home/ubuntu/.openclaw/workspace/ai-podcast && /usr/bin/python3 main.py --check-only >> logs/generate.log 2>&1

# 每天早上 7:00 发送播客
0 7 * * * cd /home/ubuntu/.openclaw/workspace/ai-podcast && /usr/bin/python3 main.py --send-only >> logs/send.log 2>&1
```

---

## 🎯 使用示例

### 示例 1：处理单个视频

```bash
python main.py --single VIDEO_ID
```

**输出**：
- 字幕：`data/transcript_VIDEO_ID.txt`
- 脚本：`data/script_VIDEO_ID.txt`
- 音频：`audio/podcast_VIDEO_ID.mp3`

---

### 示例 2：测试模式

```bash
python main.py --test
```

使用预设的测试视频，快速验证系统是否正常。

---

### 示例 3：完整流程

```bash
python main.py
```

完整流程：
1. 检查所有频道的新视频
2. 过滤低质量内容
3. 获取字幕
4. 生成播客脚本
5. 生成语音
6. 发送到 Telegram

---

## 📁 项目结构

```
ai-podcast/
├── config.json          # 配置文件
├── channels.json        # 博主列表
├── requirements.txt     # Python 依赖
├── main.py             # 主程序
├── utils.py            # 工具函数
├── monitor.py          # 视频监控模块
├── transcript.py       # 字幕获取模块
├── summarizer.py       # AI 总结模块
├── tts.py              # TTS 语音合成模块
├── sender.py           # Telegram 推送模块
├── data/               # 数据目录
│   ├── videos.db      # 视频数据库
│   └── background.mp3 # 背景音乐（可选）
├── audio/              # 音频输出目录
└── logs/               # 日志目录
```

---

## ⚙️ 配置说明

### config.json

```json
{
  "api_keys": {
    "youtube_api_key": "...",
    "gemini_api_key": "...",
    "telegram_bot_token": "...",
    "telegram_chat_id": "..."
  },
  "podcast": {
    "language": "zh-CN",              // 播客语言
    "voice": "zh-CN-XiaoxiaoNeural",  // TTS 声音
    "duration_minutes": 10,           // 目标时长
    "max_videos_per_day": 5,          // 每天最多处理视频数
    "output_dir": "audio",            // 输出目录
    "background_music": "data/background.mp3"  // 背景音乐（可选）
  },
  "schedule": {
    "check_interval_hours": 2,        // 检查间隔
    "generate_time": "06:00",         // 生成时间
    "send_time": "07:00"              // 发送时间
  },
  "filters": {
    "min_video_duration_seconds": 300,  // 最短视频时长
    "min_views": 1000,                  // 最少播放量
    "keywords": ["AI", "GPT", ...]      // 关键词过滤
  }
}
```

---

## 🔧 自定义博主列表

编辑 `channels.json`：

```json
[
  {
    "name": "博主名称",
    "channel_id": "UC...",  // YouTube 频道 ID
    "category": "tutorial",  // 分类
    "priority": 5,           // 优先级（1-5）
    "enabled": true          // 是否启用
  }
]
```

**获取频道 ID**：
1. 访问频道主页
2. 查看源代码
3. 搜索 `channelId`

---

## 📊 监控与调试

### 查看日志

```bash
# 查看今天的日志
tail -f logs/main_$(date +%Y%m%d).log

# 查看所有日志
ls -lh logs/
```

---

### 数据库查询

```bash
# 查看已处理的视频
sqlite3 data/videos.db "SELECT * FROM videos ORDER BY processed_at DESC LIMIT 10;"
```

---

## 💡 高级功能

### 1. 添加背景音乐

```bash
# 将音乐文件放到 data/background.mp3
cp your_music.mp3 data/background.mp3
```

系统会自动添加背景音乐。

---

### 2. 自定义播客脚本

编辑 `summarizer.py` 中的 `prompt` 模板。

---

### 3. 多语言支持

修改 `config.json`：

```json
{
  "podcast": {
    "language": "en-US",
    "voice": "en-US-JennyNeural"
  }
}
```

---

## 🐛 故障排查

### 问题 1：字幕获取失败

**原因**：视频可能没有字幕

**解决**：跳过该视频，或使用 Whisper 本地转写

---

### 问题 2：Telegram 发送失败

**原因**：Bot Token 或 Chat ID 错误

**解决**：
1. 检查 @BotFather 的 Token
2. 确认 @userinfobot 的 Chat ID

---

### 问题 3：API 配额超限

**原因**：YouTube API 有每日限制

**解决**：
1. 使用 yt-dlp 替代 YouTube API
2. 申请更高的配额

---

## 📈 成本分析

**完全免费方案**：
- YouTube API：免费（10,000 units/天）
- Gemini Pro：免费（60 requests/min）
- Edge TTS：免费
- Telegram：免费

**总成本**：**$0/月**

---

## 🎊 效果展示

### Telegram 推送示例

```
☀️ 早安！今天的 AI 技术播客已生成。

📊 内容来源: Andrej Karpathy, Lex Fridman, 安格视界
🎬 视频数量: 3 个
🎧 收听时长: 约 12 分钟

📝 核心内容:
1. GPT-5 最新特性深度解析
2. Andrej Karpathy 谈 AI 未来
3. OpenClaw 最佳部署实践

#AI #Podcast #Daily
```

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📝 更新日志

**2026-02-27**：
- ✅ 初始版本发布
- ✅ 支持 30+ AI 博主监控
- ✅ 集成 Gemini Pro 总结
- ✅ 集成 Edge TTS
- ✅ Telegram 自动推送

---

## 📄 许可证

MIT License

---

**创建时间**：2026-02-27
**维护者**：OpenClaw AI

🦞 **每天早上 7:00，AI 播客准时送达！**
