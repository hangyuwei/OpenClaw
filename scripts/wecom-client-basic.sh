#!/bin/bash
# 企业微信日程同步 - 基础版本

WORKSPACE="$HOME/.openclaw/workspace"
CONFIG_FILE="$WORKSPACE/config/wecom-config.json"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

echo "📅 企业微信日程同步 - $DATE $TIME"
echo "================================"

# 检查配置文件
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ 配置文件不存在"
  echo "请先创建配置文件："
  echo "  cp $WORKSPACE/config/wecom-config.example.json $CONFIG_FILE"
  echo "  nano $CONFIG_FILE"
  echo ""
  echo "然后填入你的企业微信 API 凭证。"
  exit 1
fi

# 读取配置
CORP_ID=$(jq -r '.wecom.corp_id // empty' "$CONFIG_FILE")
AGENT_ID=$(jq -r '.wecom.agent_id // empty' "$CONFIG_FILE")
SECRET=$(jq -r '.wecom.secret // empty' "$CONFIG_FILE")
USER_ID=$(jq -r '.wecom.user_id // empty' "$CONFIG_FILE")

# 验证配置
if [ -z "$CORP_ID" ] || [ -z "$SECRET" ]; then
  echo "❌ 配置不完整，请检查："
  echo "  - corp_id"
  echo "  - secret"
  exit 1
fi

echo "✅ 配置已加载"

# 获取 Access Token
echo "🔄 正在获取 Access Token..."

TOKEN_URL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CORP_ID&corpsecret=$SECRET"
RESPONSE=$(curl -s "$TOKEN_URL")

ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token // empty')

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
  echo "❌ 获取 Access Token 失败"
  echo "响应：$RESPONSE"
  exit 1
fi

echo "✅ Access Token 已获取"

# 获取日程数据（示例）
echo "🔄 正在获取日程数据..."

NOW=$(date +%s)
DAYS_AHEAD=$(jq -r '.sync_settings.days_ahead // 7' "$CONFIG_FILE")
END_TIME=$((NOW + DAYS_AHEAD * 24 * 3600))

# 注意：这里的 API 端点需要根据企业微信实际文档调整
# SCHEDULE_API="https://qyapi.weixin.qq.com/cgi-bin/schedule/list?access_token=$ACCESS_TOKEN"

# 创建日程目录
SCHEDULE_DIR="$WORKSPACE/obsidian-vault/日程"
mkdir -p "$SCHEDULE_DIR"

# 生成示例日程报告
REPORT_FILE="$SCHEDULE_DIR/$DATE.md"

cat > "$REPORT_FILE" << EOF
# 📅 日程安排 - $DATE

> 同步时间：$TIME
> 数据来源：企业微信
> 覆盖范围：未来 $DAYS_AHEAD 天

---

## 📋 今日日程

⚠️ **注意**：这是示例数据

要获取真实日程，请：

1. 确认企业微信 API 已开通
2. 检查 API 权限设置
3. 验证用户 ID 是否正确

---

## 🎥 今日会议

暂无会议

---

## ⏰ 即将到来的日程

待同步...

---

## 💡 提醒设置

- [ ] 重要会议提前 30 分钟提醒
- [ ] 检查会议资料准备
- [ ] 确认参会人员

---

## 📊 配置信息

- 企业 ID：$CORP_ID
- 应用 ID：$AGENT_ID
- 用户 ID：${USER_ID:-未配置}

---

**下次同步**：$(date -d "+1 hour" +%H:%M)
EOF

echo "✅ 日程报告已生成：$REPORT_FILE"

# 同步到 Git
SYNC_TO_GIT=$(jq -r '.output.sync_to_git // false' "$CONFIG_FILE")

if [ "$SYNC_TO_GIT" == "true" ]; then
  echo "🔄 同步到 Git..."

  cd "$WORKSPACE/obsidian-vault"
  git add "日程/$DATE.md"
  git commit -m "📅 日程同步 - $DATE"
  git push

  echo "✅ 已同步到 GitHub"
fi

echo ""
echo "================================"
echo "✅ 日程同步完成！"
echo ""
echo "📋 查看日程："
echo "  cat $REPORT_FILE"
echo ""
echo "⚙️ 配置定时任务："
echo "  crontab -e"
echo "  添加：0 * * * * $WORKSPACE/scripts/wecom-sync.sh"
