#!/usr/bin/env bash

# expansion is intended, therefore double-quoting is not desired,

#shellcheck disable=SC2016,SC2207
declare -a choice=(
  $(
    tmux list-panes -a \
      -F "#{session_name} #{window_name} #{pane_title} #{pane_id}" |
      fzf --preview "tmux capture-pane -peJ -t {1}"
  )
)

if [ ${#choice[@]} -eq 0 ]; then
  exit 0
fi

tmux switch-client -t "${choice[0]}:${choice[1]}.${choice[3]}"
# EOF
