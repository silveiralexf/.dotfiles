#!/bin/bash
# ---------------------------------------------------------------------------
# This script will setup the dotfiles into your ${HOME} directory
#
# The following utils will be installed by this script:
#   - fzf (https://github.com/junegunn/fzf)
#   - vimrc_runtime (https://github.com/amix/vimrc)
#   - pet snippet (https://github.com/knqyf263/pet)
#
# The following is recommended to be installed, but not covered
# by this install script:
#   - GNU Source-highlight (http://www.gnu.org/software/src-highlite/)
#   - Conky (http://conky.sourceforge.net)
#
# ---------------------------------------------------------------------------
BASEDIR="${HOME}/.dotfiles"

main() {

	# Add dotfiles to PATH by updating ${HOME}/.bashrc
	if [ -f "${BASEDIR}/files/dotfiles.source" ]; then
		grep -q ^"# Source bash dotfiles" ~/.bashrc ||
			cat "${BASEDIR}/files/dotfiles.source" >>"${HOME}/.bashrc"
	else
		msg_missing_util
	fi

	# Setup fzf or die trying
	if [ -f "${BASEDIR}/utils/fzf.tar" ]; then
		tar -C "${BASEDIR}/" -xvf "${BASEDIR}/utils/fzf.tar"
	else
		msg_missing_util
	fi

	# Check pet snippet or die trying
	if [ -x "${BASEDIR}/utils/pet" ]; then
		chmod 755 "${BASEDIR}/utils/pet"
	else
		msg_missing_util
	fi

	# Copy TMUX conf file if TMUX is found on server
	[ -f "$(whereis tmux | awk '{ print $2 }')" ] && cp "${BASEDIR}/files/tmux.conf" "${HOME}/.tmux.conf"

	# Copy htop profile
	[ -f "$(whereis htop | awk '{ print $2 }')" ] && cp "${BASEDIR}/files/htoprc" "${HOME}/.config/htop/htoprc"

	# Copy gitconfig if none is found
	[ -f "${BASEDIR}/files/gitconfig" ] || cp "${BASEDIR}/files/gitconfig" "${HOME}/.gitconfig"

	# Copy gpg.conf from dotfiles
	[ -f "${HOME}/.gnupg/gpg.conf" ] && cp "${BASEDIR}/files/gpg.conf" "${BASEDIR}/files/gpg.conf"

	# When available setup .conkyrc from dotfiles
	[ ! -f "${HOME}/.conkyrc" ] && ln -s "${BASEDIR}/files/conkyrc" "${HOME}/.conkyrc"

	# If all goes well tell user the good news
	msg_success
}

msg_missing_util() {
	echo "ERROR: Could not find required utils to proceed. Exiting!"
	echo ""
	exit 1
}

msg_success() {
	echo "SUCCESS: Dotfiles were deployed and changes will take place on"
	echo "        the next terminal session that you start."
	exit 0
}

# ---------------------------------------------------------------------------
main "$@"

# EOF
