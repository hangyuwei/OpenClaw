#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - 字幕获取模块
"""

from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api._errors import TranscriptsDisabled, NoTranscriptFound
from utils import setup_logger

logger = setup_logger("transcript")

class TranscriptFetcher:
    """字幕获取器"""

    def __init__(self, languages=['en', 'zh-CN', 'zh-Hans']):
        self.languages = languages
        logger.info(f"字幕获取器初始化，支持语言: {languages}")

    def fetch_transcript(self, video_id):
        """获取视频字幕"""
        try:
            # 尝试获取指定语言的字幕
            transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)

            # 优先选择中文
            try:
                transcript = transcript_list.find_transcript(['zh-CN', 'zh-Hans', 'zh'])
                logger.info(f"找到中文字幕: {video_id}")
            except:
                # 如果没有中文，尝试英文
                try:
                    transcript = transcript_list.find_transcript(['en'])
                    logger.info(f"找到英文字幕: {video_id}")
                except:
                    # 使用自动生成的字幕
                    transcript = transcript_list.find_generated_transcript(['en'])
                    logger.info(f"使用自动生成字幕: {video_id}")

            # 获取字幕内容
            transcript_data = transcript.fetch()

            # 合并文本
            full_text = ' '.join([entry['text'] for entry in transcript_data])

            logger.info(f"字幕获取成功，总字数: {len(full_text)}")
            return full_text

        except TranscriptsDisabled:
            logger.warning(f"该视频禁用了字幕: {video_id}")
            return None
        except NoTranscriptFound:
            logger.warning(f"未找到字幕: {video_id}")
            return None
        except Exception as e:
            logger.error(f"获取字幕失败: {e}")
            return None

    def fetch_with_timestamps(self, video_id):
        """获取带时间戳的字幕"""
        try:
            transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)

            # 尝试中文
            try:
                transcript = transcript_list.find_transcript(['zh-CN', 'zh-Hans', 'zh'])
            except:
                transcript = transcript_list.find_transcript(['en'])

            transcript_data = transcript.fetch()

            # 格式化输出
            formatted = []
            for entry in transcript_data:
                timestamp = self.format_timestamp(entry['start'])
                text = entry['text']
                formatted.append({
                    'timestamp': timestamp,
                    'text': text,
                    'start': entry['start'],
                    'duration': entry['duration']
                })

            logger.info(f"带时间戳字幕获取成功: {video_id}")
            return formatted

        except Exception as e:
            logger.error(f"获取带时间戳字幕失败: {e}")
            return []

    @staticmethod
    def format_timestamp(seconds):
        """格式化时间戳"""
        minutes = int(seconds // 60)
        secs = int(seconds % 60)
        return f"{minutes:02d}:{secs:02d}"

def main():
    """测试"""
    fetcher = TranscriptFetcher()

    # 测试视频 ID（安格视界的 OpenClaw 视频）
    video_id = "Zh9IscszDQg"

    print(f"获取字幕: {video_id}")
    transcript = fetcher.fetch_transcript(video_id)

    if transcript:
        print(f"\n字幕内容（前 500 字）:")
        print(transcript[:500])
        print(f"\n总字数: {len(transcript)}")
    else:
        print("字幕获取失败")

if __name__ == "__main__":
    main()
