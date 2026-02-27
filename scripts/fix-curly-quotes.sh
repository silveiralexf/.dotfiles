#!/usr/bin/env bash
# Pre-commit helper: normalize curly quotes and other characters that break parsers.
# Replaces: smart quotes → ASCII, nbsp → space, en/em dash → -, ellipsis → ...; removes ZWSP, ZWNJ, ZWJ, BOM.
# Portable: BSD sed (macOS) and GNU sed; uses gsed on macOS when available.

set -e

if [[ "$(uname -s)" = Darwin ]] && command -v gsed &>/dev/null; then
  SED="gsed"
else
  SED="sed"
fi

DQ_LEFT=$(printf '\342\200\234')
DQ_RIGHT=$(printf '\342\200\235')
SQ_LEFT=$(printf '\342\200\230')
SQ_RIGHT=$(printf '\342\200\231')
NBSP=$(printf '\302\240')
EN_DASH=$(printf '\342\200\223')
EM_DASH=$(printf '\342\200\224')
ELLIPSIS=$(printf '\342\200\246')
ZWSP=$(printf '\342\200\213')
ZWNJ=$(printf '\342\200\214')
ZWJ=$(printf '\342\200\215')
BOM=$(printf '\357\273\277')

changed=0

for f in "$@"; do
  [[ -f "$f" ]] || continue
  tmp=$(mktemp)
  if "$SED" \
    -e "s/${DQ_LEFT}/\"/g" \
    -e "s/${DQ_RIGHT}/\"/g" \
    -e "s/${SQ_LEFT}/'/g" \
    -e "s/${SQ_RIGHT}/'/g" \
    -e "s/${NBSP}/ /g" \
    -e "s/${EN_DASH}/-/g" \
    -e "s/${EM_DASH}/-/g" \
    -e "s/${ELLIPSIS}/.../g" \
    -e "s/${ZWSP}//g" \
    -e "s/${ZWNJ}//g" \
    -e "s/${ZWJ}//g" \
    -e "s/${BOM}//g" \
    "$f" > "$tmp"; then
    if ! cmp -s "$f" "$tmp"; then
      mv "$tmp" "$f"
      changed=1
    else
      rm -f "$tmp"
    fi
  else
    rm -f "$tmp"
    exit 1
  fi
done

[[ $changed -eq 0 ]]
