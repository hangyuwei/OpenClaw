---
name: obsidian
description: "操作 Obsidian 笔记库（读取/创建/更新/搜索）"
argument-hint: "[read|create|update|search] [path]"
---

# Obsidian 笔记操作

连接到你的 Obsidian Vault，实现 AI 辅助笔记管理。

## Vault 位置

```
~/.openclaw/workspace/obsidian-vault/
```

## 功能

### 1. 读取笔记
```
读取: obsidian read "工作流程/服务器连接.md"
```

### 2. 创建笔记
```
创建: obsidian create "项目笔记/新项目.md" --content "内容"
```

### 3. 更新笔记
```
更新: obsidian update "首页.md" --append "新内容"
```

### 4. 搜索内容
```
搜索: obsidian search "关键词"
```

### 5. 同步
```
同步: obsidian sync
```

## 自动同步

- **Cron 任务**: 每 5 分钟自动执行
- **同步逻辑**:
  1. 先 pull 远程更新（你修改的）
  2. 再检查本地变更（我修改的）
  3. 有变更就 commit & push
- **冲突处理**: Git rebase 自动处理
- **日志位置**: `/tmp/obsidian-sync.log`

## 使用示例

### 示例 1：创建今日笔记
```
用户：帮我创建今天的每日笔记
我：好的，让我创建...
→ 使用 Templates/Daily Note.md 模板
→ 创建 2026-02-27.md
→ 自动 commit
```

### 示例 2：搜索笔记
```
用户：我有关于 OpenClaw 的笔记吗？
我：让我搜索...
→ 找到 3 个相关笔记
→ 显示内容摘要
```

### 示例 3：更新笔记
```
用户：在经验库/调试经验中记录这个问题
我：好的，让我追加...
→ 读取文件
→ 追加新内容
→ commit & push
```

## 注意事项

1. **冲突处理** - 如果本地和远程都有修改，需要手动解决
2. **敏感信息** - 账号密码等不要放入 Vault
3. **大文件** - 避免提交大型二进制文件
4. **备份** - 依赖 Git 历史，随时可回滚

---
*Obsidian + Git = AI 可以读写的知识库*
