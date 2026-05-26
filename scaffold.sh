#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/PauloFerreira25/base-devcontainer.git"
TARGET_DIR="${1:-}"

if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: scaffold <target-directory>"
  exit 1
fi

TARGET_DIR="$(realpath "$TARGET_DIR")"
PROJECT_NAME="$(basename "$TARGET_DIR")"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: target directory does not exist: $TARGET_DIR"
  exit 1
fi

echo "Repo     : $REPO"
echo "Target   : $TARGET_DIR"
echo "Project  : $PROJECT_NAME"
echo ""

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Fetching template..."
git clone --depth=1 --quiet "$REPO" "$TEMP_DIR/repo"
echo "Done."
echo ""

IGNORE_LIST=()
if [[ -f "$TEMP_DIR/repo/.scaffoldignore" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    IGNORE_LIST+=("$line")
  done < "$TEMP_DIR/repo/.scaffoldignore"
fi

should_ignore() {
  local filepath="$1"
  for pattern in "${IGNORE_LIST[@]:-}"; do
    [[ "$filepath" == "$pattern" ]] && return 0
  done
  return 1
}

copy_file() {
  local src="$1"
  local dst="$2"
  local rel="$3"

  mkdir -p "$(dirname "$dst")"

  if [[ -f "$dst" ]]; then
    echo -n "Already exists: $rel — overwrite? [y/N] "
    read -r answer || answer=""
    case "$answer" in
      [yY]*) ;;
      *) echo "  Skipped."; return ;;
    esac
  fi

  if grep -qI . "$src"; then
    sed "s/base-devcontainer/$PROJECT_NAME/g" "$src" > "$dst"
  else
    cp "$src" "$dst"
  fi
  echo "  Copied: $rel"
}

while IFS= read -r filepath; do
  should_ignore "$filepath" && continue
  copy_file "$TEMP_DIR/repo/$filepath" "$TARGET_DIR/$filepath" "$filepath"
done < <(git -C "$TEMP_DIR/repo" ls-files)

echo ""
echo "Done. Scaffolded '$PROJECT_NAME' into $TARGET_DIR"
