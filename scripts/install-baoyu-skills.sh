#!/bin/bash
# Baoyu Skills 快速安装脚本

echo "🎨 Baoyu Skills 安装向导"
echo "========================"
echo ""
echo "正在安装超强内容生成技能库..."
echo ""

# 检查 Node.js 环境
if ! command -v node &> /dev/null; then
    echo "❌ 错误：未检测到 Node.js 环境"
    echo "请先安装 Node.js: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js 版本：$(node -v)"
echo ""

# 安装 Baoyu Skills
echo "📦 开始安装 Baoyu Skills..."
echo ""

# 方法 1：使用 npx skills
if npx skills add jimliu/baoyu-skills; then
    echo ""
    echo "✅ 安装成功！"
    echo ""
else
    echo ""
    echo "⚠️ 自动安装失败，尝试手动安装..."
    echo ""
    echo "请手动运行以下命令："
    echo ""
    echo "# 方法 1：快速安装"
    echo "npx skills add jimliu/baoyu-skills"
    echo ""
    echo "# 方法 2：注册为插件市场"
    echo "/plugin marketplace add jimliu/baoyu-skills"
    echo ""
    echo "# 方法 3：安装特定插件"
    echo "/plugin install content-skills@baoyu-skills"
    echo "/plugin install ai-generation-skills@baoyu-skills"
    echo "/plugin install utility-skills@baoyu-skills"
    echo ""
    exit 1
fi

# 显示使用示例
echo "📚 使用示例："
echo ""
echo "1. 小红书图文生成："
echo "   /baoyu-xhs-images article.md --style cute --layout balanced"
echo ""
echo "2. 专业信息图表："
echo "   /baoyu-infographic content.md --layout pyramid --style technical-schematic"
echo ""
echo "3. 网页转 Markdown："
echo "   /baoyu-url-to-markdown https://example.com/article"
echo ""
echo "4. 查看所有技能："
echo "   /plugin list"
echo ""

echo "🎉 安装完成！开始创作精彩内容吧！"
echo ""
echo "📖 完整文档："
echo "   ~/.openclaw/workspace/obsidian-vault/Baoyu-Skills使用指南.md"
echo ""
