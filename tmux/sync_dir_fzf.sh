#!/usr/bin/env sh

set -u

if [ "${1:-}" = "--popup" ]; then
  roots=$(tmux show-option -gqv @sync_dir_roots)
  if [ -z "$roots" ]; then
    roots="$HOME/projects"
  fi

  maxdepth=$(tmux show-option -gqv @sync_dir_maxdepth)
  if [ -z "$maxdepth" ]; then
    maxdepth=4
  fi

  list=$(
    IFS=':'
    for root in $roots; do
      [ -d "$root" ] || continue
      find "$root" -maxdepth "$maxdepth" -type d -name .git -prune -print 2>/dev/null \
        | sed 's|/\.git$||'
    done | sort -u
  )

  if [ -z "$list" ]; then
    list=$(
      IFS=':'
      for root in $roots; do
        [ -d "$root" ] || continue
        printf '%s\n' "$root"
      done | sort -u
    )
  fi

  config_dir="$HOME/.config"
  if [ -d "$config_dir" ]; then
    list=$(printf '%s\n' "$list" "$config_dir" | sed '/^$/d' | sort -u)
  fi

  target=$(printf '%s\n' "$list" | fzf --prompt="Project dir > " --no-multi) || exit 0

  # Quote path to preserve spaces and special characters.
  quoted=$(printf "'%s'" "$(printf '%s' "$target" | sed "s/'/'\\\\''/g")")
  tmux setw synchronize-panes on
  tmux send-keys "cd -- $quoted" C-m
  tmux send-keys "clear" C-m
  tmux setw synchronize-panes off
  exit 0
fi

start_dir="${1:-$HOME}"
if [ ! -d "$start_dir" ]; then
  start_dir="$HOME"
fi

tmux display-popup -E -w 90% -h 70% -d "$start_dir" sh -lc "$HOME/.config/tmux/sync_dir_fzf.sh --popup"
