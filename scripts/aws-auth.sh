#!/usr/bin/env bash

sops_path=$(which sops)
enc_file="${DOTFILES_PROFILE}/private"
dec_file="${enc_file}.dec"

if [[ -x $sops_path ]]; then
  sops -d "${enc_file}" >"${dec_file}" &&
    chmod +x "${dec_file}" &&
    source "${dec_file}"
  rm -rf "${dec_file}"
else
  printf "WARNING: SOPS not found, nothing done!\n"
  exit 1
fi

if command -v aws-vault >/dev/null; then
  aws-vault exec feedzai-eu-01 --mfa-token="$(oathtool --totp --base32 --digits=6 ${AWS_MAIN_IAM_TOTP_KEY})" --duration=1h --json
  exit 0
else
  echo 'aws-vault not found, brew install it and try again' 1>&2
  git add -u
fi
