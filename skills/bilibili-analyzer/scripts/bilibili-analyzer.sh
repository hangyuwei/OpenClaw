#!/bin/bash
# B 站视频解析器
# 用法: ./bilibili-analyzer.sh "https://www.bilibili.com/video/BV1xx4y1k7tD"

set -e

URL="$1"
WORK_DIR="/tmp/bilibili-analyzer"
mkdir -p "$WORK_DIR"

echo "🔍 解析 B 站视频: $URL"
echo ""

# 步骤 1: 获取视频信息
echo "📡 获取视频信息..."
you-get --info "$URL" > "$WORK_DIR/info.txt" 2>&1
cat "$WORK_DIR/info.txt"

echo ""
echo "✅ 视频信息已保存到: $WORK_DIR/info.txt"
echo ""

# 步骤 2: 下载视频片段（前30秒，限制8MB）
echo "⬇️  下载视频片段（前30秒）..."
cd "$WORK_DIR"

# 使用 you-get 下载
timeout 60 you-get -O video "$URL" || echo "下载超时或失败"

# 查找下载的视频文件
VIDEO_FILE=$(find "$WORK_DIR" -name "*.mp4" -o -name "*.flv" | head -1)

if [ -f "$VIDEO_FILE" ]; then
    echo "✅ 视频已下载: $VIDEO_FILE"
    
    # 裁剪前30秒
    echo "✂️  裁剪视频片段..."
    ffmpeg -y -i "$VIDEO_FILE" -t 30 -c:v libx264 -crf 28 -preset fast -c:a aac -b:a 128k "$WORK_DIR/clip.mp4" 2>/dev/null || echo "裁剪失败"
    
    # 提取关键帧
    echo "📸 提取关键帧..."
    ffmpeg -y -i "$WORK_DIR/clip.mp4" -vf "fps=1/3,scale=640:-1" "$WORK_DIR/frame_%03d.jpg" 2>/dev/null || echo "关键帧提取失败"
    
    echo ""
    echo "✅ 关键帧已保存到: $WORK_DIR/"
    ls -lh "$WORK_DIR"/*.jpg 2>/dev/null | head -10
else
    echo "⚠️  视频下载失败，仅获取到信息"
fi

echo ""
echo "📊 分析完成！文件位置: $WORK_DIR/"
