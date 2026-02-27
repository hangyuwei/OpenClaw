#!/usr/bin/env python3
"""
OpenClaw 记忆系统 v1.0
使用 LanceDB 实现持久化记忆
"""

import lancedb
from datetime import datetime
import hashlib
import json
from pathlib import Path

class MemorySystem:
    def __init__(self, db_path="~/.openclaw/memory/lancedb"):
        self.db_path = Path(db_path).expanduser()
        self.db_path.mkdir(parents=True, exist_ok=True)
        self.db = lancedb.connect(str(self.db_path))
        self.init_tables()

    def init_tables(self):
        """初始化记忆表"""
        # 对话记忆表
        if "conversation_memory" not in self.db.table_names():
            self.db.create_table("conversation_memory", [
                {
                    "id": "init",
                    "timestamp": datetime.now().isoformat(),
                    "text": "系统初始化",
                    "vector": [0.0] * 128,
                    "category": "system",
                    "metadata": "{}"
                }
            ])

        # 知识记忆表
        if "knowledge_memory" not in self.db.table_names():
            self.db.create_table("knowledge_memory", [
                {
                    "id": "init",
                    "timestamp": datetime.now().isoformat(),
                    "text": "知识库初始化",
                    "vector": [0.0] * 128,
                    "category": "system",
                    "source": "system",
                    "metadata": "{}"
                }
            ])

        # 技能记忆表
        if "skill_memory" not in self.db.table_names():
            self.db.create_table("skill_memory", [
                {
                    "id": "init",
                    "timestamp": datetime.now().isoformat(),
                    "text": "技能库初始化",
                    "vector": [0.0] * 128,
                    "skill_name": "init",
                    "description": "初始化",
                    "triggers": "[]",
                    "metadata": "{}"
                }
            ])

        # 错误记忆表
        if "error_memory" not in self.db.table_names():
            self.db.create_table("error_memory", [
                {
                    "id": "init",
                    "timestamp": datetime.now().isoformat(),
                    "text": "错误库初始化",
                    "vector": [0.0] * 128,
                    "error_type": "system",
                    "solution": "初始化",
                    "metadata": "{}"
                }
            ])

        print("✅ 记忆系统初始化完成")

    def _text_to_vector(self, text, dim=128):
        """将文本转换为向量（简单哈希实现）"""
        # 使用哈希生成伪向量（实际应用中应使用 embedding 模型）
        vector = []
        for i in range(dim):
            hash_val = hash(f"{text}_{i}") % 1000 / 1000.0
            vector.append(hash_val)
        return vector

    def add_conversation(self, user_input, ai_response, category="general", metadata=None):
        """添加对话记忆"""
        memory_id = hashlib.md5(f"{user_input}{datetime.now()}".encode()).hexdigest()
        timestamp = datetime.now().isoformat()
        text = f"用户：{user_input}\nAI：{ai_response}"
        vector = self._text_to_vector(text)

        table = self.db.open_table("conversation_memory")
        table.add([{
            "id": memory_id,
            "timestamp": timestamp,
            "text": text,
            "vector": vector,
            "category": category,
            "metadata": json.dumps(metadata or {})
        }])

        print(f"✅ 对话记忆已保存: {memory_id[:8]}")
        return memory_id

    def add_knowledge(self, text, category="general", source="learning", metadata=None):
        """添加知识记忆"""
        memory_id = hashlib.md5(f"{text}{datetime.now()}".encode()).hexdigest()
        timestamp = datetime.now().isoformat()
        vector = self._text_to_vector(text)

        table = self.db.open_table("knowledge_memory")
        table.add([{
            "id": memory_id,
            "timestamp": timestamp,
            "text": text,
            "vector": vector,
            "category": category,
            "source": source,
            "metadata": json.dumps(metadata or {})
        }])

        print(f"✅ 知识记忆已保存: {memory_id[:8]}")
        return memory_id

    def add_skill(self, skill_name, description, triggers, code=None, metadata=None):
        """添加技能记忆"""
        memory_id = hashlib.md5(f"{skill_name}{datetime.now()}".encode()).hexdigest()
        timestamp = datetime.now().isoformat()
        text = f"技能：{skill_name}\n描述：{description}"
        vector = self._text_to_vector(text)

        table = self.db.open_table("skill_memory")
        table.add([{
            "id": memory_id,
            "timestamp": timestamp,
            "text": text,
            "vector": vector,
            "skill_name": skill_name,
            "description": description,
            "triggers": json.dumps(triggers or []),
            "metadata": json.dumps(metadata or {})
        }])

        print(f"✅ 技能记忆已保存: {skill_name}")
        return memory_id

    def add_error(self, error_type, error_msg, solution, metadata=None):
        """添加错误记忆"""
        memory_id = hashlib.md5(f"{error_type}{datetime.now()}".encode()).hexdigest()
        timestamp = datetime.now().isoformat()
        text = f"错误类型：{error_type}\n错误信息：{error_msg}\n解决方案：{solution}"
        vector = self._text_to_vector(text)

        table = self.db.open_table("error_memory")
        table.add([{
            "id": memory_id,
            "timestamp": timestamp,
            "text": text,
            "vector": vector,
            "error_type": error_type,
            "solution": solution,
            "metadata": json.dumps(metadata or {})
        }])

        print(f"✅ 错误记忆已保存: {error_type}")
        return memory_id

    def search_conversation(self, query, limit=5):
        """搜索对话记忆"""
        table = self.db.open_table("conversation_memory")
        vector = self._text_to_vector(query)
        results = table.search(vector).limit(limit).to_list()
        return results

    def search_knowledge(self, query, limit=5):
        """搜索知识记忆"""
        table = self.db.open_table("knowledge_memory")
        vector = self._text_to_vector(query)
        results = table.search(vector).limit(limit).to_list()
        return results

    def search_skill(self, query, limit=5):
        """搜索技能记忆"""
        table = self.db.open_table("skill_memory")
        vector = self._text_to_vector(query)
        results = table.search(vector).limit(limit).to_list()
        return results

    def search_error(self, query, limit=5):
        """搜索错误记忆"""
        table = self.db.open_table("error_memory")
        vector = self._text_to_vector(query)
        results = table.search(vector).limit(limit).to_list()
        return results

    def get_all_memories(self, table_name="conversation_memory"):
        """获取所有记忆"""
        table = self.db.open_table(table_name)
        return table.to_pandas().to_dict('records')

    def get_memory_stats(self):
        """获取记忆统计"""
        stats = {}
        for table_name in self.db.table_names():
            table = self.db.open_table(table_name)
            stats[table_name] = len(table.to_pandas())
        return stats

    def export_to_obsidian(self, output_dir="~/.openclaw/workspace/obsidian-vault/记忆导出"):
        """导出记忆到 Obsidian"""
        output_path = Path(output_dir).expanduser()
        output_path.mkdir(parents=True, exist_ok=True)

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        export_file = output_path / f"记忆导出_{timestamp}.md"

        with open(export_file, 'w', encoding='utf-8') as f:
            f.write(f"# 记忆导出\n\n")
            f.write(f"导出时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")

            # 导出知识记忆
            f.write("## 📚 知识记忆\n\n")
            knowledge = self.get_all_memories("knowledge_memory")
            for item in knowledge:
                if item['id'] != 'init':
                    f.write(f"### {item['category']}\n\n")
                    f.write(f"{item['text']}\n\n")
                    f.write(f"来源：{item['source']}\n\n")
                    f.write(f"时间：{item['timestamp']}\n\n")
                    f.write("---\n\n")

            # 导出技能记忆
            f.write("## 🔧 技能记忆\n\n")
            skills = self.get_all_memories("skill_memory")
            for item in skills:
                if item['id'] != 'init':
                    f.write(f"### {item['skill_name']}\n\n")
                    f.write(f"{item['description']}\n\n")
                    f.write(f"触发词：{item['triggers']}\n\n")
                    f.write(f"时间：{item['timestamp']}\n\n")
                    f.write("---\n\n")

            # 导出错误记忆
            f.write("## ❌ 错误记忆\n\n")
            errors = self.get_all_memories("error_memory")
            for item in errors:
                if item['id'] != 'init':
                    f.write(f"### {item['error_type']}\n\n")
                    f.write(f"{item['text']}\n\n")
                    f.write(f"时间：{item['timestamp']}\n\n")
                    f.write("---\n\n")

        print(f"✅ 记忆已导出到: {export_file}")
        return str(export_file)


def main():
    """测试记忆系统"""
    print("🦞 OpenClaw 记忆系统 v1.0")
    print("=" * 50)

    # 初始化
    memory = MemorySystem()

    # 添加对话记忆
    memory.add_conversation(
        user_input="Gateway 配对问题怎么解决？",
        ai_response="修改 openclaw.json 配置文件...",
        category="技术支持"
    )

    # 添加知识记忆
    memory.add_knowledge(
        text="LanceDB 是一个嵌入式向量数据库，支持向量检索和全文搜索",
        category="技术学习",
        source="自主学习"
    )

    # 添加技能记忆
    memory.add_skill(
        skill_name="Gateway 配对修复",
        description="自动修复 Gateway 配对问题",
        triggers=["gateway", "pairing", "配对"]
    )

    # 添加错误记忆
    memory.add_error(
        error_type="Gateway 配对失败",
        error_msg="gateway pairing required",
        solution="修改 openclaw.json，删除不兼容的 pairing 字段"
    )

    # 搜索记忆
    print("\n🔍 搜索测试：")
    results = memory.search_knowledge("向量数据库")
    print(f"找到 {len(results)} 条相关知识")

    # 获取统计
    print("\n📊 记忆统计：")
    stats = memory.get_memory_stats()
    for table, count in stats.items():
        print(f"  {table}: {count} 条记忆")

    # 导出到 Obsidian
    print("\n📝 导出到 Obsidian：")
    export_file = memory.export_to_obsidian()
    print(f"导出文件：{export_file}")

    print("\n✅ 记忆系统测试完成！")


if __name__ == "__main__":
    main()
