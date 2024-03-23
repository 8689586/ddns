#!/bin/bash

# Cloudflare API 令牌
CF_API_TOKEN="YOUR_CF_API_TOKEN"
# Cloudflare Zone ID
ZONE_ID="YOUR_ZONE_ID"
# Cloudflare Record ID
RECORD_ID="YOUR_RECORD_ID"
# Cloudflare Record Name
RECORD_NAME="example.com"

# 获取当前公网 IP
current_ip=$(curl -s ifconfig.me)

# 读取上次保存的 IP
if [ -f "last_ip.txt" ]; then
    last_ip=$(cat last_ip.txt)
else
    last_ip=""
fi

# 检查 IP 是否发生变化
if [ "$current_ip" != "$last_ip" ]; then
    # 更新 Cloudflare DNS 记录
    echo "IP has changed. Updating Cloudflare DNS..."
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'$RECORD_NAME'","content":"'$current_ip'","ttl":120}'
    
    # 保存当前 IP 到文件
    echo $current_ip > last_ip.txt
else
    echo "IP has not changed."
fi
