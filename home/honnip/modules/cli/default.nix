{ pkgs, ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./shell.nix
    ./ssh.nix
  ];
  home.packages = with pkgs; [
    ripgrep
    fd
    jq

    _7zz

    nh
    nixpkgs-review
  ];

  programs.nix-index-database.comma.enable = true;

  systemd.user.sessionVariables = {
    COLORTERM = "truecolor";
  };
}
