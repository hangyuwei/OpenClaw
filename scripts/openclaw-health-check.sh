#!/bin/bash
# OpenClaw Health Check - runs every 5 minutes via cron

GATEWAY_STATUS=$(systemctl --user is-active openclaw-gateway.service 2>/dev/null)

if [ "$GATEWAY_STATUS" != "active" ]; then
    echo "[$(date)] ALERT: Gateway not active ($GATEWAY_STATUS), auto-fixing..." >> /tmp/openclaw-monitor.log
    
    # Backup and fix
    cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak-$(date +%Y%m%d-%H%M%S) 2>/dev/null
    openclaw doctor --fix 2>/dev/null
    systemctl --user restart openclaw-gateway.service openclaw-node.service
    
    sleep 3
    NEW_STATUS=$(systemctl --user is-active openclaw-gateway.service 2>/dev/null)
    echo "[$(date)] FIXED: Gateway now $NEW_STATUS" >> /tmp/openclaw-monitor.log
fi

