#!/bin/bash
# ---------------------------------------------------------------------------
# This script will setup the dotfiles into your $HOME directory
#
# The following utils will be installed by this script:
#   - fzf (https://github.com/junegunn/fzf)
#   - vimrc_runtime (https://github.com/amix/vimrc)
#   - pet snippet (https://github.com/knqyf263/pet)
#
# The following is recommended to be installed, but not covered 
# by this install script:
#   - GNU Source-highlight (http://www.gnu.org/software/src-highlite/)
#
# ---------------------------------------------------------------------------
PWD="$HOME/.dotfiles"

main() {
    
    # Add dotfiles to PATH by updating $HOME/.bashrc
    if [ -f "$PWD/files/dotfiles.source" ]; then
        grep -q ^"# Source bash dotfiles" ~/.bashrc ||\
        cat "$PWD/files/dotfiles.source" >> "$HOME/.bashrc"
    else
        msg_missing_util
    fi
    
    # Setup fzf or die trying
    [ -f "$PWD/utils/fzf.tar" ] && tar -C "$PWD/" -xvf "./utils/fzf.tar" || msg_missing_util
    
    # Setup vim_runtime or die trying
    [ -f "$PWD/utils/vim_runtime.tar" ] &&\
          (tar -C "$HOME/" -xvf "./utils/vim_runtime.tar" &&\
          cp "$PWD/files/my_configs.vim" "$HOME/.vim_runtime/my_configs.vim") ||\
          msg_missing_util

    # Check pet snippet or die trying
    [ -x "$PWD/utils/pet" ] && chmod 755 "$PWD/utils/pet" || msg_missing_util
    
    # Copy TMUX conf file if TMUX is found on server
    [ -f "$(whereis tmux | awk '{ print $2 }')" ] && cp "$PWD/files/tmux.conf" "$HOME/.tmux.conf"

    # Copy gitconfig if none is found
    [ -f "$PWD/files/gitconfig" ] || cp "$PWD/files/gitconfig" "$HOME/.gitconfig"

    # If all goes well tell user the good news
    msg_success
}

msg_missing_util() {
    echo "ERROR: Could not find required utils to proceed. Exiting!"
    echo ""
    exit 1
}

msg_success() {
    echo "SUCCES: Dotfiles were deployed and changes will take place on" 
    echo "        the next terminal session that you start."
    exit 0
}
# ---------------------------------------------------------------------------
main "$@"

