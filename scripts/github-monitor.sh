#!/bin/bash
# GitHub 仓库监控（每天执行）
# 自动发现项目中的问题

LOG_FILE="/tmp/github-monitor.log"
OBSIDIAN_DIR="/home/ubuntu/.openclaw/workspace/obsidian-vault"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始 GitHub 监控..." >> "$LOG_FILE"

# 创建目录
mkdir -p "$OBSIDIAN_DIR/项目笔记/GitHub-Issues"

# 监控你的仓库
REPOS=(
    "hangyuwei/health-assessment"
    "hangyuwei/OpenClaw"
)

for REPO in "${REPOS[@]}"; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 检查 $REPO" >> "$LOG_FILE"

    # 获取最新的 5 个 issues
    ISSUES=$(gh issue list --repo "$REPO" --state open --limit 5 --json number,title,createdAt 2>/dev/null)

    if [ -n "$ISSUES" ]; then
        echo "$ISSUES" | jq -r '.[] | "\(.number)|\(.title)|\(.createdAt)"' | while IFS='|' read NUM TITLE CREATED; do
            # 检查是否已记录
            if ! grep -r "Issue #$NUM" "$OBSIDIAN_DIR/项目笔记/GitHub-Issues/" 2>/dev/null; then
                NOTE_FILE="$OBSIDIAN_DIR/项目笔记/GitHub-Issues/${REPO//\//-}-Issue-$NUM.md"

                cat > "$NOTE_FILE" << EOF
# GitHub Issue #$NUM

> 发现时间: $(date '+%Y-%m-%d %H:%M:%S')
> 创建时间: $CREATED

## 标题

$TITLE

## 来源

https://github.com/$REPO/issues/$NUM

## 状态

- [ ] 待分析
- [ ] 待解决
- [ ] 待验证

## 分析

（待 AI 分析）

## 解决方案

（待提供）

## 相关笔记

-

---

#GitHub #Issue #$REPO
EOF

                echo "[✓] 记录新 Issue: #$NUM - $TITLE" >> "$LOG_FILE"
            fi
        done
    fi
done

# 同步到 Git
cd "$OBSIDIAN_DIR"
git add -A
git commit -m "🔍 GitHub 监控: 发现新 Issues" 2>/dev/null
git push 2>/dev/null

echo "[$(date '+%Y-%m-%d %H:%M:%S')] GitHub 监控完成" >> "$LOG_FILE"
