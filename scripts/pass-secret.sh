#!/bin/sh

menu() {
	cd ~/.password-store && find . -name "*.gpg" | sed 's/.gpg//g'
}

main() {
	choice=$(menu | choose -b ff79c6 -w 48 -n 7)
	pass -c "$choice"
}

main
