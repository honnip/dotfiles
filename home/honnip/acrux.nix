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
  '';
}
