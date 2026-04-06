#!/usr/bin/env bash
# install-skills.sh — 从 JXNU-PUBLISH-skills 仓库安装项目级 skills
# 已存在的 skill 目录不会被覆盖

set -euo pipefail

REPO="guiguisocute/JXNU-PUBLISH-skills"
REF="${JXNU_PUBLISH_SKILLS_REF:-main}"
SKILLS_DIR="./skills"
REQUIRED_SKILLS=(
  daily-reconcile
  incremental-process
  map-source
  merge-supplement
  parse-and-create-cards
  validate-and-push
  write-conclusion
  write-worklog
)

# 检查是否有需要安装的 skill
needs_install=false
for skill in "${REQUIRED_SKILLS[@]}"; do
  if [ ! -d "$SKILLS_DIR/$skill" ]; then
    needs_install=true
    break
  fi
done

if [ "$needs_install" = false ]; then
  echo "All skills already installed, nothing to do."
  exit 0
fi

# 创建临时目录用于 sparse checkout
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Cloning $REPO@$REF (sparse checkout: skills/) ..."
git clone --depth 1 --branch "$REF" --filter=blob:none --sparse \
  "https://github.com/$REPO.git" "$tmpdir" 2>/dev/null

cd "$tmpdir"
git sparse-checkout set skills/
cd - > /dev/null

# 逐个复制缺失的 skill
mkdir -p "$SKILLS_DIR"
for skill in "${REQUIRED_SKILLS[@]}"; do
  src="$tmpdir/skills/$skill"
  dst="$SKILLS_DIR/$skill"
  if [ -d "$dst" ]; then
    echo "skip: $skill (already exists)"
  elif [ -d "$src" ]; then
    cp -r "$src" "$dst"
    echo "installed: $skill"
  else
    echo "WARNING: $skill not found in $REPO@$REF"
  fi
done

echo "Done."
