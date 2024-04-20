{ pkgs, ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./fish.nix
    ./helix.nix
    ./gpg.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
  ];
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    eza
  ];

  systemd.user.sessionVariables = {
    COLORTERM = "truecolor";
  };
}
