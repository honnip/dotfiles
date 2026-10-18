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

  # Unlock GNOME Keyring from an SSH session. The keyring then
  # serves stored SSH keys without ssh-add for the rest of the boot.
  programs.fish.functions.keyring-unlock = {
    description = "Unlock the GNOME Keyring for this boot";
    body = ''
      read --silent --prompt-str 'Keyring password: ' pw
      gnome-keyring-daemon --start > /dev/null
      printf '%s' $pw | gnome-keyring-daemon --unlock
      and echo 'Keyring unlocked'
      set -e pw
    '';
  };
}
