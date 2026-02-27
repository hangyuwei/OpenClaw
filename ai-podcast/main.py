#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - 主程序
"""

import asyncio
import sys
from datetime import datetime
from pathlib import Path

# 添加项目路径
sys.path.insert(0, str(Path(__file__).parent))

from utils import load_config, load_channels, setup_logger, get_video_by_id, mark_video_processed
from monitor import YouTubeMonitor
from transcript import TranscriptFetcher
from summarizer import ContentSummarizer
from tts import generate_podcast_audio
from sender import TelegramSender

logger = setup_logger("main")

class AIPodcastSystem:
    """AI 播客自动化系统"""

    def __init__(self):
        self.config = load_config()
        self.channels = load_channels()

        # 初始化各模块
        self.monitor = YouTubeMonitor()
        self.transcript_fetcher = TranscriptFetcher()
        self.summarizer = ContentSummarizer()
        self.sender = TelegramSender()

        logger.info("AI Podcast 系统初始化完成")

    def check_new_videos(self, max_per_channel=5):
        """检查新视频"""
        logger.info("=" * 50)
        logger.info("开始检查新视频...")
        logger.info("=" * 50)

        videos = self.monitor.check_all_channels(max_per_channel)
        return videos

    def process_video(self, video_info):
        """处理单个视频"""
        video_id = video_info['video_id']
        logger.info(f"\n处理视频: {video_info['title']}")

        # 1. 获取字幕
        logger.info("步骤 1/3: 获取字幕...")
        transcript = self.transcript_fetcher.fetch_transcript(video_id)

        if not transcript:
            logger.warning(f"跳过视频（无字幕）: {video_id}")
            return None

        # 2. 生成播客脚本
        logger.info("步骤 2/3: 生成播客脚本...")
        script = self.summarizer.summarize_to_podcast_script(
            transcript,
            video_info.get('title', ''),
            video_info.get('channel_name', '')
        )

        if not script:
            logger.error(f"生成脚本失败: {video_id}")
            return None

        # 3. 生成语音
        logger.info("步骤 3/3: 生成语音...")
        output_filename = f"podcast_{video_id}.mp3"
        audio_path = asyncio.run(generate_podcast_audio(script, output_filename))

        if not audio_path:
            logger.error(f"生成语音失败: {video_id}")
            return None

        # 标记为已处理
        mark_video_processed(video_id, transcript, script, audio_path)

        logger.info(f"✅ 视频处理完成: {video_id}")
        return {
            'video_info': video_info,
            'script': script,
            'audio_path': audio_path
        }

    def generate_daily_podcast(self, videos):
        """生成每日综合播客"""
        if not videos:
            logger.warning("没有视频可处理")
            return None

        logger.info("=" * 50)
        logger.info("开始生成每日综合播客...")
        logger.info("=" * 50)

        # 限制视频数量
        max_videos = self.config['podcast']['max_videos_per_day']
        selected_videos = videos[:max_videos]

        # 处理每个视频
        processed = []
        for video in selected_videos:
            result = self.process_video(video)
            if result:
                processed.append(result)

        if not processed:
            logger.error("没有成功处理的视频")
            return None

        # 如果只有一个视频，直接返回
        if len(processed) == 1:
            return processed[0]

        # 多个视频：生成综合播客
        logger.info("\n生成综合播客...")

        # 合并所有字幕
        all_transcripts = []
        for result in processed:
            video_info = result['video_info']
            transcript = self.transcript_fetcher.fetch_transcript(video_info['video_id'])
            if transcript:
                all_transcripts.append({
                    'title': video_info['title'],
                    'channel_name': video_info['channel_name'],
                    'transcript': transcript
                })

        # 生成综合脚本
        combined_script = self.summarizer.generate_daily_digest(all_transcripts)

        if not combined_script:
            logger.error("生成综合脚本失败")
            return None

        # 生成语音
        today = datetime.now().strftime("%Y%m%d")
        output_filename = f"daily_podcast_{today}.mp3"
        audio_path = asyncio.run(generate_podcast_audio(combined_script, output_filename))

        if not audio_path:
            logger.error("生成综合语音失败")
            return None

        logger.info(f"✅ 每日播客生成完成: {audio_path}")
        return {
            'videos_info': selected_videos,
            'script': combined_script,
            'audio_path': audio_path
        }

    def send_podcast(self, podcast_data):
        """发送播客到 Telegram"""
        if not podcast_data:
            logger.warning("没有播客可发送")
            return False

        audio_path = podcast_data.get('audio_path')
        videos_info = podcast_data.get('videos_info', [])

        logger.info("=" * 50)
        logger.info("发送播客到 Telegram...")
        logger.info("=" * 50)

        success = self.sender.send_daily_podcast(audio_path, videos_info)

        if success:
            logger.info("✅ 播客发送成功")
        else:
            logger.error("❌ 播客发送失败")

        return success

    def run(self, check_only=False, send_only=False, test_mode=False):
        """运行完整流程"""
        logger.info("🎙️ AI Podcast 自动化系统启动")
        logger.info(f"时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

        if send_only:
            # 仅发送模式（用于定时任务）
            # 从数据库中获取今天已处理的播客
            logger.info("仅发送模式")
            # TODO: 实现从数据库加载
            return False

        if test_mode:
            # 测试模式：使用示例视频
            logger.info("测试模式")
            test_video = {
                'video_id': 'Zh9IscszDQg',
                'title': 'OpenClaw 最佳部署教程',
                'channel_name': '安格视界',
                'published_at': '2026-02-23T00:00:00Z'
            }
            podcast = self.process_video(test_video)
            if podcast and not check_only:
                self.send_podcast(podcast)
            return True

        # 正常模式
        # 1. 检查新视频
        videos = self.check_new_videos()

        if not videos:
            logger.info("没有发现新视频")
            return True

        # 2. 生成播客
        podcast = self.generate_daily_podcast(videos)

        if not podcast:
            logger.error("播客生成失败")
            return False

        # 3. 发送播客
        if not check_only:
            self.send_podcast(podcast)

        logger.info("\n" + "=" * 50)
        logger.info("✅ AI Podcast 系统运行完成")
        logger.info("=" * 50)
        return True

def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(description='AI Podcast 自动化系统')
    parser.add_argument('--check-only', action='store_true', help='仅检查新视频，不发送')
    parser.add_argument('--send-only', action='store_true', help='仅发送播客')
    parser.add_argument('--test', action='store_true', help='测试模式')
    parser.add_argument('--single', type=str, help='处理单个视频（提供 video_id）')

    args = parser.parse_args()

    system = AIPodcastSystem()

    if args.single:
        # 处理单个视频
        video_info = {
            'video_id': args.single,
            'title': 'Unknown',
            'channel_name': 'Unknown'
        }
        result = system.process_video(video_info)
        if result:
            print(f"\n✅ 播客生成成功: {result['audio_path']}")
        else:
            print("\n❌ 播客生成失败")
    else:
        # 运行完整流程
        success = system.run(
            check_only=args.check_only,
            send_only=args.send_only,
            test_mode=args.test
        )

        sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
