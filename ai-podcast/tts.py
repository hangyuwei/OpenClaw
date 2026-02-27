#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - TTS 语音合成模块
"""

import asyncio
import edge_tts
from pathlib import Path
from pydub import AudioSegment
from utils import load_config, setup_logger, PROJECT_ROOT

logger = setup_logger("tts")

class PodcastTTS:
    """播客语音合成器"""

    def __init__(self):
        config = load_config()
        self.voice = config['podcast']['voice']
        self.output_dir = PROJECT_ROOT / config['podcast']['output_dir']
        self.output_dir.mkdir(exist_ok=True)
        logger.info(f"TTS 初始化成功，使用语音: {self.voice}")

    async def text_to_speech(self, text, output_filename="podcast.mp3"):
        """文本转语音"""
        try:
            output_path = self.output_dir / output_filename

            logger.info(f"开始生成语音，字数: {len(text)}")

            # 创建 Communicate 对象
            communicate = edge_tts.Communicate(text, self.voice)

            # 生成语音
            await communicate.save(str(output_path))

            logger.info(f"语音生成成功: {output_path}")
            return str(output_path)

        except Exception as e:
            logger.error(f"语音生成失败: {e}")
            return None

    def add_background_music(self, voice_path, music_path=None, output_filename="podcast_final.mp3"):
        """添加背景音乐"""
        try:
            if not music_path:
                logger.warning("未提供背景音乐，跳过此步骤")
                return voice_path

            music_path = Path(music_path)
            if not music_path.exists():
                logger.warning(f"背景音乐文件不存在: {music_path}")
                return voice_path

            # 加载音频
            voice = AudioSegment.from_mp3(voice_path)
            music = AudioSegment.from_mp3(music_path)

            # 调整音乐音量（降低 20dB）
            music = music - 20

            # 循环音乐到与语音相同长度
            if len(music) < len(voice):
                loops_needed = (len(voice) // len(music)) + 1
                music = music * loops_needed

            music = music[:len(voice)]

            # 混合音频
            final_audio = voice.overlay(music)

            # 导出
            output_path = self.output_dir / output_filename
            final_audio.export(str(output_path), format="mp3", bitrate="128k")

            logger.info(f"背景音乐添加成功: {output_path}")
            return str(output_path)

        except Exception as e:
            logger.error(f"添加背景音乐失败: {e}")
            return voice_path

    def get_audio_duration(self, audio_path):
        """获取音频时长（秒）"""
        try:
            audio = AudioSegment.from_mp3(audio_path)
            return len(audio) / 1000  # 转换为秒
        except Exception as e:
            logger.error(f"获取音频时长失败: {e}")
            return 0

    def split_long_text(self, text, max_chars=5000):
        """将长文本分段（Edge TTS 有字符限制）"""
        if len(text) <= max_chars:
            return [text]

        # 按段落分割
        paragraphs = text.split('\n\n')
        chunks = []
        current_chunk = ""

        for para in paragraphs:
            if len(current_chunk) + len(para) <= max_chars:
                current_chunk += para + "\n\n"
            else:
                if current_chunk:
                    chunks.append(current_chunk)
                current_chunk = para + "\n\n"

        if current_chunk:
            chunks.append(current_chunk)

        logger.info(f"文本已分为 {len(chunks)} 段")
        return chunks

async def generate_podcast_audio(script, output_filename="podcast.mp3"):
    """生成播客音频（便捷函数）"""
    tts = PodcastTTS()

    # 分段处理长文本
    chunks = tts.split_long_text(script)

    if len(chunks) == 1:
        # 短文本，直接生成
        return await tts.text_to_speech(script, output_filename)
    else:
        # 长文本，分段生成后合并
        temp_files = []
        for i, chunk in enumerate(chunks):
            temp_file = f"temp_{i}.mp3"
            await tts.text_to_speech(chunk, temp_file)
            temp_files.append(tts.output_dir / temp_file)

        # 合并音频
        combined = AudioSegment.empty()
        for temp_file in temp_files:
            audio = AudioSegment.from_mp3(temp_file)
            combined += audio

        # 导出最终文件
        output_path = tts.output_dir / output_filename
        combined.export(str(output_path), format="mp3", bitrate="128k")

        # 清理临时文件
        for temp_file in temp_files:
            temp_file.unlink()

        logger.info(f"播客音频生成成功: {output_path}")
        return str(output_path)

async def main():
    """测试"""
    # 测试脚本
    test_script = """
[开场]
早上好！欢迎收听今天的 AI 技术播客。
今天是 2026 年 2 月 27 日，星期四。
我是你的 AI 主播，今天要为你介绍最新的 AI 技术动态。

[观点 1]
第一个重要消息是关于 GPT-5 的发布。
OpenAI 最新发布的 GPT-5 在推理能力上有了显著提升。
它不仅能更好地理解复杂问题，还能生成更高质量的代码。

[结尾]
以上就是今天的 AI 技术播客。
感谢你的收听，明天早上 7 点，我们不见不散！
"""

    print("测试: 生成播客音频")
    output_path = await generate_podcast_audio(test_script, "test_podcast.mp3")

    if output_path:
        print(f"\n✅ 音频生成成功: {output_path}")

        # 获取时长
        tts = PodcastTTS()
        duration = tts.get_audio_duration(output_path)
        print(f"⏱️  音频时长: {duration:.1f} 秒")

if __name__ == "__main__":
    asyncio.run(main())
