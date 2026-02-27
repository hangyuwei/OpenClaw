#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - 视频监控模块
"""

import os
from datetime import datetime, timedelta
from googleapiclient.discovery import build
from utils import load_config, load_channels, setup_logger, save_video_info, get_video_by_id

logger = setup_logger("monitor")

class YouTubeMonitor:
    """YouTube 视频监控器"""

    def __init__(self, api_key=None):
        config = load_config()
        self.api_key = api_key or config['api_keys']['youtube_api_key']
        self.youtube = build('youtube', 'v3', developerKey=self.api_key)
        self.filters = config['filters']
        logger.info("YouTube 监控器初始化成功")

    def get_latest_videos(self, channel_id, max_results=10):
        """获取频道最新视频"""
        try:
            # 获取频道的 uploads 播放列表 ID
            channels_response = self.youtube.channels().list(
                part='contentDetails',
                id=channel_id
            ).execute()

            if not channels_response['items']:
                logger.warning(f"频道不存在: {channel_id}")
                return []

            uploads_playlist_id = channels_response['items'][0]['contentDetails']['relatedPlaylists']['uploads']

            # 获取播放列表中的视频
            playlist_response = self.youtube.playlistItems().list(
                part='snippet,contentDetails',
                playlistId=uploads_playlist_id,
                maxResults=max_results
            ).execute()

            videos = []
            for item in playlist_response['items']:
                video_id = item['contentDetails']['videoId']

                # 检查是否已存在
                if get_video_by_id(video_id):
                    continue

                # 获取视频详细信息
                video_details = self.get_video_details(video_id)
                if not video_details:
                    continue

                # 过滤
                if not self.should_process(video_details):
                    continue

                video_info = {
                    'video_id': video_id,
                    'channel_name': item['snippet']['channelTitle'],
                    'title': item['snippet']['title'],
                    'published_at': item['snippet']['publishedAt'],
                    'duration': video_details['duration'],
                    'views': video_details['views'],
                    'description': item['snippet']['description'],
                    'thumbnail': item['snippet']['thumbnails']['high']['url']
                }

                videos.append(video_info)
                save_video_info(video_info)

            logger.info(f"从频道 {channel_id} 获取了 {len(videos)} 个新视频")
            return videos

        except Exception as e:
            logger.error(f"获取视频失败: {e}")
            return []

    def get_video_details(self, video_id):
        """获取视频详细信息"""
        try:
            response = self.youtube.videos().list(
                part='contentDetails,statistics',
                id=video_id
            ).execute()

            if not response['items']:
                return None

            item = response['items'][0]

            # 解析时长 (PT1H2M10S -> 3730 秒)
            duration_str = item['contentDetails']['duration']
            duration_seconds = self.parse_duration(duration_str)

            return {
                'duration': duration_seconds,
                'views': int(item['statistics'].get('viewCount', 0))
            }

        except Exception as e:
            logger.error(f"获取视频详情失败: {e}")
            return None

    def parse_duration(self, duration_str):
        """解析 ISO 8601 时长格式"""
        import re
        match = re.match(r'PT(\d+H)?(\d+M)?(\d+S)?', duration_str)
        if not match:
            return 0

        hours = int(match.group(1)[:-1]) if match.group(1) else 0
        minutes = int(match.group(2)[:-1]) if match.group(2) else 0
        seconds = int(match.group(3)[:-1]) if match.group(3) else 0

        return hours * 3600 + minutes * 60 + seconds

    def should_process(self, video_details):
        """判断是否应该处理该视频"""
        # 时长过滤
        if video_details['duration'] < self.filters['min_video_duration_seconds']:
            return False

        # 播放量过滤
        if video_details['views'] < self.filters['min_views']:
            return False

        return True

    def check_all_channels(self, max_per_channel=5):
        """检查所有频道的新视频"""
        channels = load_channels()
        all_videos = []

        for channel in channels:
            if not channel.get('enabled', True):
                continue

            logger.info(f"检查频道: {channel['name']}")
            videos = self.get_latest_videos(
                channel['channel_id'],
                max_results=max_per_channel
            )

            for video in videos:
                video['channel_name'] = channel['name']
                video['priority'] = channel.get('priority', 3)
                video['category'] = channel.get('category', 'general')

            all_videos.extend(videos)

        # 按优先级和发布时间排序
        all_videos.sort(key=lambda x: (
            -x.get('priority', 3),
            x['published_at']
        ))

        logger.info(f"总共发现 {len(all_videos)} 个新视频")
        return all_videos

def main():
    """主函数"""
    monitor = YouTubeMonitor()
    videos = monitor.check_all_channels()

    print(f"\n发现 {len(videos)} 个新视频:")
    for i, video in enumerate(videos[:10], 1):
        print(f"{i}. [{video['channel_name']}] {video['title']}")
        print(f"   发布时间: {video['published_at']}")
        print(f"   时长: {video['duration']}秒, 观看: {video['views']}次")
        print()

if __name__ == "__main__":
    main()
