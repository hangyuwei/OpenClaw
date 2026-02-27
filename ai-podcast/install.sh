#!/bin/bash

# AI Podcast 自动化系统 - 安装脚本

set -e

echo "🎙️ AI Podcast 自动化系统安装脚本"
echo "================================"

# 检查 Python 版本
echo "检查 Python 版本..."
if ! command -v python3 &> /dev/null; then
    echo "❌ 错误: 未找到 Python3"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "✅ Python 版本: $PYTHON_VERSION"

# 检查 pip
if ! command -v pip3 &> /dev/null; then
    echo "❌ 错误: 未找到 pip3"
    exit 1
fi
echo "✅ pip3 已安装"

# 创建目录
echo "创建目录..."
mkdir -p data audio logs
echo "✅ 目录创建完成"

# 安装依赖
echo "安装 Python 依赖..."
pip3 install -r requirements.txt
echo "✅ 依赖安装完成"

# 检查配置文件
if [ ! -f "config.json" ]; then
    echo "⚠️  警告: config.json 不存在，请手动配置 API Keys"
    echo "   参考 README.md 获取 API Keys"
fi

# 检查 channels.json
if [ ! -f "channels.json" ]; then
    echo "⚠️  警告: channels.json 不存在"
fi

echo ""
echo "================================"
echo "✅ 安装完成！"
echo ""
echo "下一步："
echo "1. 编辑 config.json 配置 API Keys"
echo "2. 运行测试: python3 main.py --test"
echo "3. 设置定时任务（参考 README.md）"
echo ""
echo "📚 文档: cat README.md"
echo "🧪 测试: python3 main.py --test"
echo "🚀 运行: python3 main.py"
echo ""
