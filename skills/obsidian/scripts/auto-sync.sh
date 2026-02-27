#!/bin/bash
# Obsidian Vault 自动同步
# 由 cron 每 5 分钟调用一次

VAULT_DIR="/home/ubuntu/.openclaw/workspace/obsidian-vault"
LOG_FILE="/tmp/obsidian-sync.log"

cd "$VAULT_DIR" || exit 1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始同步..." >> "$LOG_FILE"

# 先拉取远程更新
git fetch origin >> "$LOG_FILE" 2>&1
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 发现远程更新，开始 pull..." >> "$LOG_FILE"
    git pull --rebase origin main >> "$LOG_FILE" 2>&1
fi

# 检查本地变更
if [[ -n $(git status -s) ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 发现本地变更，开始 commit & push..." >> "$LOG_FILE"
    git add -A >> "$LOG_FILE" 2>&1
    git commit -m "🔄 Auto sync: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1
    git push origin main >> "$LOG_FILE" 2>&1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 同步完成" >> "$LOG_FILE"
