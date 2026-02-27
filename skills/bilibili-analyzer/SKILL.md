---
name: bilibili-analyzer
description: "解析 B 站视频内容，绕过被墙限制"
argument-hint: "[bilibili_url]"
---

# B 站视频解析器

解决 B 站视频被墙问题，通过关键帧提取 + AI 分析理解视频内容。

## 工作流程

```
1. you-get 获取视频信息和下载链接
2. ffmpeg 下载片段或提取关键帧
3. image 工具分析关键帧
4. 生成内容总结
```

## 使用方式

```bash
# 分析 B 站视频
bilibili-analyzer "https://www.bilibili.com/video/BV1xx4y1k7tD"
```

## 输出内容

- 视频标题、简介、UP主
- 关键帧截图（10-20张）
- AI 分析结果：
  - 场景描述
  - 人物/物体识别
  - 内容总结

## 技术栈

- `you-get` - 下载 B 站视频
- `ffmpeg` - 视频处理
- `image` - AI 视觉分析
