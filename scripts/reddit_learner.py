#!/usr/bin/env python3
"""
Reddit 热门内容学习器
自动采集 Reddit 热门帖子，分析并保存到记忆库
"""

import json
import sys
sys.path.append('/home/ubuntu/.openclaw/workspace/memory')
from memory_system import MemorySystem
from datetime import datetime
import subprocess

def fetch_reddit_hot_json(subreddit, limit=10):
    """使用 curl 获取 Reddit 热门（JSON 格式）"""
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit={limit}"
    headers = "User-Agent: OpenClaw-Bot/1.0"

    try:
        result = subprocess.run(
            f"curl -s -A '{headers}' '{url}'",
            shell=True,
            capture_output=True,
            text=True,
            timeout=30
        )

        if result.returncode == 0:
            data = json.loads(result.stdout)
            posts = []

            for child in data['data']['children']:
                post = child['data']
                posts.append({
                    'title': post['title'],
                    'url': f"https://reddit.com{post['permalink']}",
                    'score': post['score'],
                    'num_comments': post['num_comments'],
                    'author': post.get('author', '[deleted]'),
                    'created': datetime.fromtimestamp(post['created_utc']).isoformat()
                })

            return posts
        else:
            print(f"❌ 获取失败: {result.stderr}")
            return []
    except Exception as e:
        print(f"❌ 错误: {e}")
        return []

def analyze_post_value(post):
    """分析帖子价值（简单规则）"""
    # 规则：高赞 + 高评论 = 高价值
    if post['score'] > 100 and post['num_comments'] > 50:
        return "高价值"
    elif post['score'] > 50 or post['num_comments'] > 20:
        return "中等价值"
    else:
        return "低价值"

def learn_from_subreddit(subreddit, limit=20):
    """从指定 subreddit 学习"""
    print(f"\n🔍 采集 r/{subreddit} 热门内容...")

    posts = fetch_reddit_hot_json(subreddit, limit)

    if not posts:
        print(f"⚠️  r/{subreddit} 没有获取到内容")
        return []

    print(f"✅ 获取到 {len(posts)} 个帖子")

    # 初始化记忆系统
    memory = MemorySystem()
    learned = []

    for post in posts:
        # 分析价值
        value = analyze_post_value(post)

        if value != "低价值":
            # 保存到记忆库
            knowledge_text = f"""
标题：{post['title']}
来源：r/{subreddit}
链接：{post['url']}
热度：{post['score']} upvotes, {post['num_comments']} comments
作者：{post['author']}
时间：{post['created']}
价值：{value}
"""

            memory.add_knowledge(
                text=knowledge_text,
                category=f"Reddit-{subreddit}",
                source="Reddit",
                metadata={
                    'url': post['url'],
                    'score': post['score'],
                    'value': value
                }
            )

            learned.append(post)
            print(f"  ✅ {post['title'][:50]}... [{value}]")

    return learned

def main():
    """主函数"""
    print("🔥 Reddit 热门内容学习器")
    print("=" * 60)

    # 要学习的 subreddit
    subreddits = [
        "MachineLearning",
        "artificial",
        "ChatGPT",
        "OpenAI",
        "LocalLLaMA"
    ]

    total_learned = []

    for subreddit in subreddits:
        learned = learn_from_subreddit(subreddit, limit=10)
        total_learned.extend(learned)

    # 统计
    print("\n📊 学习统计：")
    print(f"  总共学习：{len(total_learned)} 个帖子")

    # 导出到 Obsidian
    print("\n📝 导出到 Obsidian...")
    memory = MemorySystem()
    export_file = memory.export_to_obsidian()
    print(f"  导出文件：{export_file}")

    print("\n✅ 学习完成！")

if __name__ == "__main__":
    main()
