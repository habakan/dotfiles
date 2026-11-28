#!/bin/sh
set -eu

config_dir="$HOME/.gemini/config"
skills_dir="$config_dir/skills"
mkdir -p "$skills_dir"

# 参照先が消えた symlink を掃除する (実ディレクトリには触れない)
find "$skills_dir" -maxdepth 1 -type l | while IFS= read -r link; do
  if [ ! -e "$link" ]; then
    rm -f "$link"
  fi
done

link_skills() {
  for s in "$@"; do
    if [ -d "$s" ] && [ -f "$s/SKILL.md" ]; then
      ln -sfn "$s" "$skills_dir/$(basename "$s")"
    fi
  done
}

# 外部スキル (.agents/skills/*) を先に張り、自作スキル (~/work/skills) で上書きする
if [ -d /opt/dotfiles/ext-skills ]; then
  link_skills /opt/dotfiles/ext-skills/*
fi

if [ -d /opt/dotfiles/own-skills ]; then
  link_skills \
    /opt/dotfiles/own-skills/* \
    /opt/dotfiles/own-skills/meta/* \
    /opt/dotfiles/own-skills/bot/*
fi

if [ -f /opt/dotfiles/AGENTS.md ]; then
  ln -sfn /opt/dotfiles/AGENTS.md "$config_dir/AGENTS.md"
elif [ -L "$config_dir/AGENTS.md" ] && [ ! -e "$config_dir/AGENTS.md" ]; then
  rm -f "$config_dir/AGENTS.md"
fi

exec agy "$@"
