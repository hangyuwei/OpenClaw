#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - 快速测试
"""

import sys
from pathlib import Path

# 添加项目路径
sys.path.insert(0, str(Path(__file__).parent))

def test_imports():
    """测试模块导入"""
    print("测试 1: 导入模块...")
    try:
        from utils import load_config, load_channels
        from monitor import YouTubeMonitor
        from transcript import TranscriptFetcher
        from summarizer import ContentSummarizer
        from tts import PodcastTTS
        from sender import TelegramSender
        print("✅ 所有模块导入成功")
        return True
    except Exception as e:
        print(f"❌ 导入失败: {e}")
        return False

def test_config():
    """测试配置加载"""
    print("\n测试 2: 加载配置...")
    try:
        from utils import load_config
        config = load_config()
        print(f"✅ 配置加载成功")
        print(f"   - 语言: {config['podcast']['language']}")
        print(f"   - 声音: {config['podcast']['voice']}")
        return True
    except Exception as e:
        print(f"❌ 配置加载失败: {e}")
        return False

def test_channels():
    """测试博主列表"""
    print("\n测试 3: 加载博主列表...")
    try:
        from utils import load_channels
        channels = load_channels()
        print(f"✅ 博主列表加载成功")
        print(f"   - 总数: {len(channels)}")
        print(f"   - 示例: {channels[0]['name']}")
        return True
    except Exception as e:
        print(f"❌ 博主列表加载失败: {e}")
        return False

def test_transcript():
    """测试字幕获取"""
    print("\n测试 4: 获取字幕...")
    try:
        from transcript import TranscriptFetcher
        fetcher = TranscriptFetcher()

        # 使用已知的视频 ID
        video_id = "Zh9IscszDQg"  # 安格视界的 OpenClaw 视频
        transcript = fetcher.fetch_transcript(video_id)

        if transcript:
            print(f"✅ 字幕获取成功")
            print(f"   - 字数: {len(transcript)}")
            print(f"   - 预览: {transcript[:100]}...")
            return True
        else:
            print("⚠️  字幕获取失败（可能没有字幕）")
            return False
    except Exception as e:
        print(f"❌ 字幕获取异常: {e}")
        return False

def test_tts():
    """测试 TTS"""
    print("\n测试 5: 测试 TTS...")
    try:
        from tts import PodcastTTS
        import asyncio

        tts = PodcastTTS()
        test_text = "这是一个测试音频。AI 播客系统运行正常。"

        print("   生成测试音频...")
        output = asyncio.run(tts.text_to_speech(test_text, "test.mp3"))

        if output:
            print(f"✅ TTS 测试成功")
            print(f"   - 输出: {output}")
            return True
        else:
            print("❌ TTS 生成失败")
            return False
    except Exception as e:
        print(f"❌ TTS 测试异常: {e}")
        return False

def main():
    """运行所有测试"""
    print("=" * 50)
    print("🎙️ AI Podcast 自动化系统 - 功能测试")
    print("=" * 50)
    print()

    tests = [
        ("模块导入", test_imports),
        ("配置加载", test_config),
        ("博主列表", test_channels),
        ("字幕获取", test_transcript),
        ("TTS 生成", test_tts)
    ]

    results = []
    for name, test_func in tests:
        try:
            result = test_func()
            results.append((name, result))
        except Exception as e:
            print(f"❌ 测试异常: {e}")
            results.append((name, False))

    # 总结
    print("\n" + "=" * 50)
    print("测试总结:")
    print("=" * 50)

    passed = sum(1 for _, result in results if result)
    total = len(results)

    for name, result in results:
        status = "✅ 通过" if result else "❌ 失败"
        print(f"{name:15s} {status}")

    print()
    print(f"通过: {passed}/{total}")

    if passed == total:
        print("\n✅ 所有测试通过！系统运行正常。")
        print("\n下一步：")
        print("1. 配置 API Keys（config.json）")
        print("2. 运行测试: python3 main.py --test")
        print("3. 设置定时任务（参考 README.md）")
        return 0
    else:
        print("\n⚠️  部分测试失败，请检查配置")
        return 1

if __name__ == "__main__":
    sys.exit(main())
