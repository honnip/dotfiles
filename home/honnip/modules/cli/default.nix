{ pkgs, lib, ... }:
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

  programs.nix-index.enable = lib.mkDefault true;
  programs.nix-index-database.comma.enable = lib.mkDefault true;

  systemd.user.sessionVariables = {
    COLORTERM = "truecolor";
  };
}
