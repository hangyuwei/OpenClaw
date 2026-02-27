#!/usr/bin/env node
/**
 * B 站视频智能分析器
 * 用法: node analyze.js "https://www.bilibili.com/video/BV1xx4y1k7tD"
 */

const { execSync, spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

const WORK_DIR = '/tmp/bilibili-analyzer';
const URL = process.argv[2];

if (!URL) {
  console.log('用法: node analyze.js "https://www.bilibili.com/video/BV1xx4y1k7tD"');
  process.exit(1);
}

// 创建工作目录
if (!fs.existsSync(WORK_DIR)) {
  fs.mkdirSync(WORK_DIR, { recursive: true });
}

console.log('🔍 B 站视频智能分析器');
console.log('📍 URL:', URL);
console.log('');

// 步骤 1: 获取视频信息
console.log('📡 步骤 1: 获取视频信息...');
try {
  const info = execSync(`you-get --info "${URL}"`, { 
    encoding: 'utf8',
    maxBuffer: 10 * 1024 * 1024 
  });
  
  // 解析信息
  const lines = info.split('\n');
  const result = {
    url: URL,
    title: '',
    author: '',
    duration: '',
    download_links: []
  };
  
  lines.forEach(line => {
    if (line.includes('Title:')) result.title = line.replace('Title:', '').trim();
    if (line.includes('Author:')) result.author = line.replace('Author:', '').trim();
    if (line.includes('Duration:')) result.duration = line.replace('Duration:', '').trim();
    if (line.includes('http')) result.download_links.push(line.trim());
  });
  
  console.log('✅ 标题:', result.title);
  console.log('✅ UP主:', result.author);
  console.log('✅ 时长:', result.duration);
  console.log('');
  
  // 保存信息
  fs.writeFileSync(path.join(WORK_DIR, 'info.json'), JSON.stringify(result, null, 2));
  
} catch (error) {
  console.error('❌ 获取信息失败:', error.message);
  console.log('');
  console.log('💡 可能的原因:');
  console.log('  - 网络连接问题');
  console.log('  - 视频被删除或私密');
  console.log('  - 需要登录访问');
  process.exit(1);
}

// 步骤 2: 下载视频片段
console.log('⬇️  步骤 2: 下载视频片段（前30秒）...');
try {
  // 先尝试获取视频URL
  const videoUrl = execSync(`you-get -u "${URL}"`, { 
    encoding: 'utf8',
    maxBuffer: 10 * 1024 * 1024 
  });
  
  console.log('✅ 找到视频链接');
  console.log('');
  
  // 下载视频
  console.log('⏬ 开始下载...');
  execSync(`cd ${WORK_DIR} && timeout 120 you-get -O video "${URL}"`, {
    stdio: 'inherit',
    timeout: 130000
  });
  
  console.log('✅ 下载完成');
  
} catch (error) {
  console.error('⚠️  下载失败:', error.message);
  console.log('');
  console.log('💡 继续使用其他方法...');
}

// 步骤 3: 处理视频
console.log('');
console.log('🎬 步骤 3: 处理视频文件...');
const videoFiles = fs.readdirSync(WORK_DIR).filter(f => 
  f.endsWith('.mp4') || f.endsWith('.flv') || f.endsWith('.mkv')
);

if (videoFiles.length > 0) {
  const videoFile = path.join(WORK_DIR, videoFiles[0]);
  console.log('✅ 找到视频:', videoFiles[0]);
  
  // 裁剪片段
  console.log('✂️  裁剪前30秒...');
  try {
    execSync(`ffmpeg -y -i "${videoFile}" -t 30 -c:v libx264 -crf 28 -preset fast -c:a aac -b:a 128k "${WORK_DIR}/clip.mp4"`, {
      stdio: 'pipe'
    });
    console.log('✅ 裁剪完成');
  } catch (e) {
    console.log('⚠️  裁剪失败，使用原视频');
  }
  
  // 提取关键帧
  console.log('📸 提取关键帧（每3秒一帧）...');
  try {
    execSync(`ffmpeg -y -i "${WORK_DIR}/clip.mp4" -vf "fps=1/3,scale=640:-1" "${WORK_DIR}/frame_%03d.jpg"`, {
      stdio: 'pipe'
    });
    
    const frames = fs.readdirSync(WORK_DIR).filter(f => f.endsWith('.jpg'));
    console.log(`✅ 提取了 ${frames.length} 个关键帧`);
    
    // 生成分析提示
    console.log('');
    console.log('📊 关键帧已保存，可以用以下命令分析:');
    console.log('');
    console.log('  image tool 分析关键帧:');
    frames.slice(0, 5).forEach((frame, i) => {
      console.log(`  Frame ${i+1}: ${WORK_DIR}/${frame}`);
    });
    
  } catch (e) {
    console.log('⚠️  关键帧提取失败');
  }
  
} else {
  console.log('⚠️  未找到视频文件');
}

// 完成
console.log('');
console.log('✅ 分析完成！');
console.log('📂 工作目录:', WORK_DIR);
console.log('');
console.log('📋 输出文件:');
const outputs = fs.readdirSync(WORK_DIR);
outputs.forEach(f => {
  const stat = fs.statSync(path.join(WORK_DIR, f));
  const size = (stat.size / 1024).toFixed(2);
  console.log(`  - ${f} (${size} KB)`);
});

console.log('');
console.log('🤖 下一步: 使用 image 工具分析关键帧');
console.log('');
