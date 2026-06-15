#!/bin/bash
echo "🚀 TOKEN DISTRIBUTION WIZARD"
read -p "Enter token address: " token
read -p "Enter decimals [18]: " decimals
decimals=${decimals:-18}
echo ""
echo "✅ Token: $token"
echo "✅ Decimals: $decimals"
