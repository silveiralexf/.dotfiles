#!/bin/sh

EXCLUSIONS='docker-credential-helpers'

menu() {
	cd ~/.password-store && find . -name "*.gpg" | grep -vE "${EXCLUSIONS}" | sed 's/.gpg//g'
}

main() {
	choice=$(menu | choose -b ff79c6 -w 48 -n 7)
	pass -c2 "$choice"
}

main
