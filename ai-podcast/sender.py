#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - Telegram 推送模块
"""

import requests
from pathlib import Path
from datetime import datetime
from utils import load_config, setup_logger, mark_video_sent

logger = setup_logger("sender")

class TelegramSender:
    """Telegram 消息发送器"""

    def __init__(self):
        config = load_config()
        self.bot_token = config['api_keys']['telegram_bot_token']
        self.chat_id = config['api_keys']['telegram_chat_id']
        self.base_url = f"https://api.telegram.org/bot{self.bot_token}"
        logger.info("Telegram 发送器初始化成功")

    def send_message(self, text, parse_mode="Markdown"):
        """发送文本消息"""
        try:
            url = f"{self.base_url}/sendMessage"

            data = {
                "chat_id": self.chat_id,
                "text": text,
                "parse_mode": parse_mode
            }

            response = requests.post(url, data=data)
            result = response.json()

            if result.get('ok'):
                logger.info("文本消息发送成功")
                return True
            else:
                logger.error(f"发送失败: {result}")
                return False

        except Exception as e:
            logger.error(f"发送消息异常: {e}")
            return False

    def send_audio(self, audio_path, caption="", title="AI Daily Podcast"):
        """发送音频文件"""
        try:
            audio_path = Path(audio_path)
            if not audio_path.exists():
                logger.error(f"音频文件不存在: {audio_path}")
                return False

            url = f"{self.base_url}/sendAudio"

            with open(audio_path, 'rb') as audio_file:
                files = {
                    'audio': (audio_path.name, audio_file, 'audio/mpeg')
                }

                data = {
                    'chat_id': self.chat_id,
                    'caption': caption,
                    'title': title,
                    'parse_mode': 'Markdown'
                }

                response = requests.post(url, files=files, data=data)
                result = response.json()

                if result.get('ok'):
                    logger.info(f"音频发送成功: {audio_path.name}")
                    return True
                else:
                    logger.error(f"发送失败: {result}")
                    return False

        except Exception as e:
            logger.error(f"发送音频异常: {e}")
            return False

    def send_daily_podcast(self, audio_path, videos_info=None):
        """发送每日播客"""
        try:
            # 生成标题
            today = datetime.now().strftime("%Y-%m-%d")
            title = f"AI Daily Podcast - {today}"

            # 生成说明文字
            caption = self._generate_caption(videos_info)

            # 发送音频
            success = self.send_audio(audio_path, caption, title)

            if success and videos_info:
                # 标记所有视频为已发送
                for video in videos_info:
                    if 'video_id' in video:
                        mark_video_sent(video['video_id'])

            return success

        except Exception as e:
            logger.error(f"发送每日播客失败: {e}")
            return False

    def _generate_caption(self, videos_info):
        """生成播客说明文字"""
        if not videos_info:
            return "☀️ 早安！今天的 AI 技术播客已生成。\n\n🎧 收听时长：约 10-15 分钟\n\n#AI #Podcast #Daily"

        # 提取视频来源
        sources = list(set([v.get('channel_name', 'Unknown') for v in videos_info[:5]]))
        sources_str = ", ".join(sources[:3])

        caption = f"""☀️ 早安！今天的 AI 技术播客已生成。

📊 **内容来源**: {sources_str}
🎬 **视频数量**: {len(videos_info)} 个
🎧 **收听时长**: 约 10-15 分钟

📝 **核心内容**:
"""

        # 添加标题列表
        for i, video in enumerate(videos_info[:5], 1):
            title = video.get('title', 'Unknown')[:50]
            caption += f"{i}. {title}\n"

        caption += "\n#AI #Podcast #Daily"

        return caption

def main():
    """测试"""
    sender = TelegramSender()

    # 测试发送消息
    print("测试 1: 发送文本消息")
    sender.send_message("🧪 测试消息：AI Podcast 系统运行正常！")

    # 测试发送音频（如果有）
    audio_path = Path("audio/test_podcast.mp3")
    if audio_path.exists():
        print("\n测试 2: 发送音频")
        sender.send_audio(audio_path, "🧪 测试音频")
    else:
        print("\n跳过音频测试（文件不存在）")

if __name__ == "__main__":
    main()
