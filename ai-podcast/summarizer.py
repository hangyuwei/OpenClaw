#!/usr/bin/env python3
"""
AI Podcast 自动化系统 - AI 总结模块
"""

import google.generativeai as genai
from utils import load_config, setup_logger

logger = setup_logger("summarizer")

class ContentSummarizer:
    """内容总结器（使用 Gemini Pro）"""

    def __init__(self, api_key=None):
        config = load_config()
        self.api_key = api_key or config['api_keys']['gemini_api_key']
        genai.configure(api_key=self.api_key)
        self.model = genai.GenerativeModel('gemini-pro')
        logger.info("Gemini Pro 模型初始化成功")

    def summarize_to_podcast_script(self, transcript, video_title="", channel_name=""):
        """将字幕总结成播客脚本"""
        try:
            prompt = f"""
你是一位专业的 AI 技术播客主持人。请将以下视频内容总结成一个 10-15 分钟的中文播客脚本。

视频标题: {video_title}
频道: {channel_name}

字幕内容:
{transcript}

要求:
1. 使用口语化、自然的表达方式
2. 提取 3-5 个核心观点，每个观点 2-3 分钟
3. 添加开场白（30 秒）：
   - 问候语
   - 介绍今天的主题
   - 提及视频来源
4. 每个核心观点之间要有过渡语句
5. 添加结尾（30 秒）：
   - 总结要点
   - 感谢收听
   - 预告明天的播客
6. 总字数约 2500-3000 字（对应 10-15 分钟语音）
7. 用中文回答

播客脚本格式:

[开场]
（开场白内容）

[观点 1]
（第一个核心观点）

[观点 2]
（第二个核心观点）

[观点 3]
（第三个核心观点）

[结尾]
（结尾内容）
"""

            logger.info("开始生成播客脚本...")
            response = self.model.generate_content(prompt)
            script = response.text

            logger.info(f"播客脚本生成成功，总字数: {len(script)}")
            return script

        except Exception as e:
            logger.error(f"生成播客脚本失败: {e}")
            return None

    def summarize_key_points(self, transcript):
        """提取关键点（简化版）"""
        try:
            prompt = f"""
请从以下内容中提取 5 个最重要的关键点，每个关键点用一句话总结：

{transcript}

要求:
1. 简洁明了
2. 突出重点
3. 用中文回答
"""

            response = self.model.generate_content(prompt)
            return response.text

        except Exception as e:
            logger.error(f"提取关键点失败: {e}")
            return None

    def generate_daily_digest(self, videos_info):
        """生成每日摘要（多个视频）"""
        try:
            # 合并所有字幕
            all_transcripts = []
            for video in videos_info:
                all_transcripts.append(f"""
视频: {video['title']}
频道: {video['channel_name']}
内容: {video['transcript'][:1000]}  # 限制长度
""")

            combined_text = "\n\n".join(all_transcripts)

            prompt = f"""
你是一位 AI 技术播客主持人。请将以下 {len(videos_info)} 个 AI 视频的核心内容总结成一个 15 分钟的中文播客脚本。

{combined_text}

要求:
1. 挑选最重要、最有趣的内容
2. 每个视频总结 1-2 分钟
3. 添加开场白和结尾
4. 使用口语化表达
5. 总字数约 3000 字
6. 用中文回答
"""

            response = self.model.generate_content(prompt)
            return response.text

        except Exception as e:
            logger.error(f"生成每日摘要失败: {e}")
            return None

def main():
    """测试"""
    summarizer = ContentSummarizer()

    # 测试文本
    test_transcript = """
    Today we're going to talk about GPT-5 and its amazing capabilities.
    GPT-5 is the latest language model from OpenAI.
    It has significantly improved reasoning capabilities compared to GPT-4.
    The model can now understand and generate code much better.
    It also has better multimodal understanding.
    """

    print("测试 1: 生成播客脚本")
    script = summarizer.summarize_to_podcast_script(
        test_transcript,
        video_title="GPT-5 深度解析",
        channel_name="AI Tech Channel"
    )

    if script:
        print("\n播客脚本:")
        print(script[:500])

    print("\n" + "="*50)
    print("测试 2: 提取关键点")
    key_points = summarizer.summarize_key_points(test_transcript)
    if key_points:
        print(key_points)

if __name__ == "__main__":
    main()
