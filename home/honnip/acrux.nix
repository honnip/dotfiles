# home-manager.users.honnip =
{
  imports = [
    ./modules/global
    ./modules/cli
    ./modules/desktop
    ./modules/desktop/factorio.nix
  ];

  # gcr-ssh-agent serves the SSH keys from GNOME Keyring.
  # SSH sessions need the socket path. The guard keeps a
  # forwarded agent when one is present.
  programs.fish.shellInit = ''
    if not set -q SSH_AUTH_SOCK
      set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gcr/ssh"
    end

    # Record the active session for the askpass dispatcher as
    # "<tty> <ssh|local> <epoch>". The dispatcher prompts on the
    # tty of an SSH session and falls back to the graphical askpass.
    function __record_session --on-event fish_postexec
      set -l t (tty 2>/dev/null)
      or return
      set -l kind local
      set -q SSH_CONNECTION; and set kind ssh
      printf '%s %s %s\n' (string replace -r '^/dev/' "" -- $t) $kind (date +%s) > "$XDG_RUNTIME_DIR/active-session"
    end
    __record_session
  '';
}
