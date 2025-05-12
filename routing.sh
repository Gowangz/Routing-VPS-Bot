#!/bin/bash
CONFIG="/opt/routing-vps-bot/config.ini"
while IFS='=' read -r domain ip; do
    [[ "$domain" =~ ^#.*$ || -z "$domain" ]] && continue
    echo "Routing $domain via $ip"
    ip route add $(dig +short $domain | head -n 1) via $ip
done < "$CONFIG"
