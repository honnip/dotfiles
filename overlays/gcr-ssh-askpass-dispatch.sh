#!/bin/sh
# Session-aware askpass for gcr-ssh-agent.
#
# gcr spawns this instead of its own gcr4-ssh-askpass. The real shim
# renders a graphical dialog through the gcr prompter. In an interactive
# SSH session we prompt on the session tty instead, so remote work never
# needs the desktop.
#
# The fish shell records the active session as "<tty> <ssh|local> <epoch>"
# in $XDG_RUNTIME_DIR/active-session. The most recent SSH record within
# the freshness window wins; everything else falls back to the graphical
# askpass.
set -eu

real="@real@"
state="${XDG_RUNTIME_DIR:-/tmp}/active-session"
window=3600

tty_name="" kind="" stamp=0
if [ -r "$state" ]; then
  read -r tty_name kind stamp <"$state" || true
fi

target=""
now=$(date +%s)
if [ "$kind" = ssh ] && [ -n "$tty_name" ] && [ -n "$stamp" ] && [ -w "/dev/$tty_name" ]; then
  if [ $((now - stamp)) -lt "$window" ]; then
    target="/dev/$tty_name"
  fi
fi

if [ -z "$target" ]; then
  exec "$real" "$@"
fi

prompt="${1:-Enter your OpenSSH passphrase}"
saved=$(stty -F "$target" -g 2>/dev/null || true)
if [ -n "$saved" ]; then
  trap 'stty -F "$target" "$saved" 2>/dev/null || true' EXIT
  stty -F "$target" -echo 2>/dev/null || true
fi

printf '\n%s ' "$prompt" >"$target"
IFS= read -r pass <"$target" || exit 1
printf '\n' >"$target"

# Record that this session unlocked a key, so the login shell
# can expire the grant when the session ends.
printf '%s\n' "$tty_name" >"${XDG_RUNTIME_DIR:-/tmp}/askpass-unlocked-by"

if [ -n "$saved" ]; then
  stty -F "$target" "$saved" 2>/dev/null || true
  trap - EXIT
fi

printf '%s\n' "$pass"
