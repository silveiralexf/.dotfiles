#!/usr/bin/env bash

# credits to:
# https://github.com/rafi/tmux-pass

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/utils.sh
source "${CURRENT_DIR}/scripts/utils.sh"

main() {
  local -r opt_key="$(get_tmux_option "@pass-key" "b")"

  tmux bind-key "$opt_key" \
    run "tmux display-popup -h 75% -w 75%  -E \"$CURRENT_DIR/scripts/main.sh '#{pane_id}'\""
}

main "$@"
