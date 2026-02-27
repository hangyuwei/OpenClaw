#!/bin/bash
# Obsidian Vault 同步脚本
# 用法: ./sync.sh [pull|push|status]

VAULT_DIR="/home/ubuntu/.openclaw/workspace/obsidian-vault"
cd "$VAULT_DIR" || exit 1

case "$1" in
  pull)
    git pull origin main
    ;;
  push)
    git add -A
    git commit -m "Auto sync from OpenClaw: $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes"
    git push origin main
    ;;
  status)
    git status
    ;;
  sync)
    git pull origin main
    if [[ -n $(git status -s) ]]; then
      git add -A
      git commit -m "Auto sync: $(date '+%Y-%m-%d %H:%M:%S')"
      git push origin main
    fi
    ;;
  *)
    echo "用法: $0 [pull|push|status|sync]"
    ;;
esac
