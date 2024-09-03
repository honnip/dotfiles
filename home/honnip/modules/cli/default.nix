{ pkgs, ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./shell.nix
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

    nh
  ];

  programs.nix-index-database.comma.enable = true;

  systemd.user.sessionVariables = {
    COLORTERM = "truecolor";
  };
}
