#!/usr/bin/env bash
# GitHub Actions 同步主脚本:从活上游拉最新资源到本仓库,调用 patch,commit
set -euo pipefail
cd "$(dirname "$0")/.."
REPO_ROOT="$PWD"

# 活上游定义:repo@ref|dst_prefix
declare -a SOURCES=(
  "blackmatrix7/ios_rule_script@master|filters/blackmatrix7/"
  "KOP-XIAO/QuantumultX@master|scripts/"
  "Koolson/Qure@master|icons/"
  "chavyleung/scripts@master|rewrites/"
)

for entry in "${SOURCES[@]}"; do
  src="${entry%%|*}"; dst="${entry##*|}"
  repo="${src%%@*}"; ref="${src##*@}"
  echo "=== 同步 $src -> $dst ==="
  tmp="$(mktemp -d)"
  git clone --depth 1 "https://github.com/$repo.git" "$tmp/clone"
  case "$repo" in
    blackmatrix7/ios_rule_script)
      for r in Apple Google YouTube Netflix TikTok Telegram Instagram Spotify Steam PayPal Microsoft Speedtest Advertising NetEaseMusic GlobalMedia Global China ChinaMedia; do
        cp "$tmp/clone/rule/QuantumultX/$r/$r.list" "$REPO_ROOT/$dst$r.list" 2>/dev/null || true
      done
      ;;
    KOP-XIAO/QuantumultX)
      cp "$tmp/clone/Scripts/resource-parser.js" "$tmp/rp-orig.js"
      "$REPO_ROOT/tools/patch-resource-parser.sh" "$tmp/rp-orig.js" "$REPO_ROOT/scripts/resource-parser.js"
      cp "$tmp/clone/Scripts/IP_bili_cn.js" "$REPO_ROOT/scripts/IP_bili_cn.js"
      ;;
    Koolson/Qure)
      mkdir -p "$REPO_ROOT/icons/IconSet"
      rsync -a --delete "$tmp/clone/IconSet/" "$REPO_ROOT/icons/IconSet/" 2>/dev/null || true
      ;;
    chavyleung/scripts)
      cp "$tmp/clone/box/rewrite/boxjs.rewrite.quanx.conf" "$REPO_ROOT/rewrites/boxjs.conf"
      cp "$tmp/clone/box/chavy.box.js" "$REPO_ROOT/scripts/chavy.boxjs.js" 2>/dev/null || true
      ;;
  esac
  rm -rf "$tmp"
done

# 仅当有变化时提交
if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "chore: 周度自动同步上游资源

由 GitHub Actions 触发
Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
  git push
  echo "✅ 已同步并提交"
else
  echo "ℹ️ 无变化,跳过提交"
fi
