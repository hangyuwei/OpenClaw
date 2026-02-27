#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - 工具函数
"""

import json
import os
import logging
from datetime import datetime
from pathlib import Path
from colorlog import ColoredFormatter

# 项目根目录
PROJECT_ROOT = Path(__file__).parent

def load_config():
    """加载配置文件"""
    config_path = PROJECT_ROOT / "config.json"
    with open(config_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def load_channels():
    """加载博主列表"""
    channels_path = PROJECT_ROOT / "channels.json"
    with open(channels_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def setup_logger(name):
    """设置彩色日志"""
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)

    # 控制台输出
    handler = logging.StreamHandler()
    handler.setLevel(logging.INFO)

    # 彩色格式
    formatter = ColoredFormatter(
        "%(log_color)s%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        log_colors={
            'DEBUG': 'cyan',
            'INFO': 'green',
            'WARNING': 'yellow',
            'ERROR': 'red',
            'CRITICAL': 'red,bg_white',
        }
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    # 文件输出
    log_dir = PROJECT_ROOT / "logs"
    log_dir.mkdir(exist_ok=True)

    file_handler = logging.FileHandler(
        log_dir / f"{name}_{datetime.now().strftime('%Y%m%d')}.log",
        encoding='utf-8'
    )
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    ))
    logger.addHandler(file_handler)

    return logger

def save_video_info(video_info):
    """保存视频信息到数据库"""
    import sqlite3

    db_path = PROJECT_ROOT / "data" / "videos.db"
    db_path.parent.mkdir(exist_ok=True)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # 创建表
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS videos (
            video_id TEXT PRIMARY KEY,
            channel_name TEXT,
            title TEXT,
            published_at TEXT,
            transcript TEXT,
            summary TEXT,
            podcast_path TEXT,
            processed_at TEXT,
            sent_at TEXT
        )
    ''')

    # 插入或更新
    cursor.execute('''
        INSERT OR REPLACE INTO videos
        (video_id, channel_name, title, published_at)
        VALUES (?, ?, ?, ?)
    ''', (
        video_info['video_id'],
        video_info.get('channel_name', ''),
        video_info.get('title', ''),
        video_info.get('published_at', '')
    ))

    conn.commit()
    conn.close()

def get_video_by_id(video_id):
    """根据 ID 获取视频信息"""
    import sqlite3

    db_path = PROJECT_ROOT / "data" / "videos.db"
    if not db_path.exists():
        return None

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute('SELECT * FROM videos WHERE video_id = ?', (video_id,))
    row = cursor.fetchone()

    conn.close()

    if row:
        return {
            'video_id': row[0],
            'channel_name': row[1],
            'title': row[2],
            'published_at': row[3],
            'transcript': row[4],
            'summary': row[5],
            'podcast_path': row[6],
            'processed_at': row[7],
            'sent_at': row[8]
        }
    return None

def mark_video_processed(video_id, transcript=None, summary=None, podcast_path=None):
    """标记视频已处理"""
    import sqlite3

    db_path = PROJECT_ROOT / "data" / "videos.db"
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute('''
        UPDATE videos
        SET transcript = ?, summary = ?, podcast_path = ?, processed_at = ?
        WHERE video_id = ?
    ''', (
        transcript,
        summary,
        podcast_path,
        datetime.now().isoformat(),
        video_id
    ))

    conn.commit()
    conn.close()

def mark_video_sent(video_id):
    """标记视频已发送"""
    import sqlite3

    db_path = PROJECT_ROOT / "data" / "videos.db"
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute('''
        UPDATE videos SET sent_at = ? WHERE video_id = ?
    ''', (datetime.now().isoformat(), video_id))

    conn.commit()
    conn.close()

if __name__ == "__main__":
    # 测试
    logger = setup_logger("test")
    logger.info("Logger 测试成功")

    config = load_config()
    print(f"配置加载成功: {config['podcast']['language']}")

    channels = load_channels()
    print(f"博主列表加载成功: {len(channels)} 个")
