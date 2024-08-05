#!/usr/bin/env bash

# Sets terminal color support
export TERM=screen-256color

NC='\033[0m' # No Color
BOLD=$(tput -T linux bold)

echo -e "🚨🚨🚨 ${BOLD} Are you sure you want to kill all sessions??? ${NC} 🚨🚨🚨 \n\n\n"
select yn in "Yes" "No"; do
  case $yn in
  Yes)
    killall tmux
    break
    ;;
  No) exit ;;
  esac
done
