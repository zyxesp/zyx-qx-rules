#!/usr/bin/env bash
# 幂等改造 resource-parser.js:三处改造
# 用法: patch-resource-parser.sh <input.js> <output.js>
set -euo pipefail

in="$1"; out="$2"
cp "$in" "$out"

# 改造1:第105行附近的自引用 KOP-XIAO → 本仓库
# 原文: resource_parser_url = https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js
NEW_URL='https://raw.githubusercontent.com/zyxesp/zyx-qx-rules/master/scripts/resource-parser.js'
# 用 perl 兼容 macOS sed,替换所有 KOP-XIAO 自引用 URL
perl -i -pe "s{https://raw\.githubusercontent\.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser\.js}{$NEW_URL}g" "$out"

# 改造2:删除所有 shrtm.nu 短链行/片段(纯展示引流,不影响功能)
perl -i -pe 's{https?://shrtm\.nu/\S+}{}g' "$out"

# 改造3:删除成对的 t.me 引流文本(ShawnKOP_Parser_Bot / QuanX_API)
# 只删出现在字符串字面量里的引流 URL,保守处理:替换为空
perl -i -pe 's{https?://t\.me/(?:ShawnKOP_Parser_Bot|QuanX_API)\S*}{}g' "$out"

echo "patched: $out"
