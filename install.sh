#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -lt 2 ]]; then
  echo "Usage: $0 <subdir> <target_path1> [<target_path2> ...]"
  exit 1
fi

subdir="$1"
shift

repo_root="$(cd "$(dirname "$0")" && pwd)"
src_path="$repo_root/$subdir"

if [[ ! -d "$src_path" ]]; then
  echo "Source subdirectory '$src_path' does not exist."
  exit 1
fi

for target in "$@"; do
  # Create the target directory if it doesn't exist
  if [[ ! -d "$target" ]]; then
    echo "Target '$target' does not exist or is not a directory. Skipping."
    continue
  fi

  link_name="$(basename "$subdir")"
  link_path="$target/$link_name"

  # Remove old symlink or directory if it exists
  if [[ -L "$link_path" || -d "$link_path" ]]; then
    rm -rf "$link_path"
  fi

  ln -s "$src_path" "$link_path"
  echo "Symlinked $src_path -> $link_path"
done
