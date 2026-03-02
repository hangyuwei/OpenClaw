#!/bin/bash
# Obsidian Auto Sync - with conflict resolution

cd /home/ubuntu/.openclaw/workspace/obsidian-vault
LOG="/tmp/obsidian-sync.log"

echo "[$(date)] Starting sync..." >> $LOG

# Fetch first
git fetch origin >> $LOG 2>&1

# Check if we need to pull
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[$(date)] Divergence detected, rebasing..." >> $LOG
    
    # Stash any local changes
    git stash >> $LOG 2>&1
    
    # Rebase on remote
    git rebase origin/main >> $LOG 2>&1
    
    # Pop stash
    git stash pop >> $LOG 2>&1
fi

# Add and commit local changes
git add -A >> $LOG 2>&1
git commit -m "🔄 Auto sync: $(date +%Y-%m-%d %H:%M:%S)" >> $LOG 2>&1 || true

# Push with rebase if needed
git push origin main >> $LOG 2>&1 || {
    echo "[$(date)] Push failed, retrying with rebase..." >> $LOG
    git pull --rebase origin main >> $LOG 2>&1
    git push origin main >> $LOG 2>&1
}

echo "[$(date)] Sync complete" >> $LOG

