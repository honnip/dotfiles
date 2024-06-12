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

    _7zz
  ];

  programs.nix-index-database.comma.enable = true;

  systemd.user.sessionVariables = {
    COLORTERM = "truecolor";
  };
}
