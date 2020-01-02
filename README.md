# dotfiles

## How to Install this dotfiles?

Clone the repository to your `$HOME` and execute the installation script as shown below:

```bash
git clone https://github.com/fsilveir/.dotfiles.git $HOME/.dotfiles
bash $HOME/.dotfiles/install_dotfiles.sh
```
If all went well a similar message should be displayed at the end:

```properties
SUCCESS: Dotfiles were deployed and changes will take place on
        the next terminal session that you start.
```

## Non-Public dotfiles

All the custom and non-public stuff should be placed at `$HOME/.dotfiles/.private`.

In case additional VIM customizations not covered by `vim_runtime` are required, placed them at `$HOME/.dotfiles/files/my_configs.vim` and re-run the installation script.

## Requirements

The following utils will be deployed by the installation script:

- [fzf](https://github.com/junegunn/fzf)
- [vimrc_runtime](https://github.com/amix/vimrc)
- [pet snippet](https://github.com/knqyf263/pet)

The following is recommended to be installed, but not covered by the installation script:

- [GNU Source-highlight](http://www.gnu.org/software/src-highlite)
