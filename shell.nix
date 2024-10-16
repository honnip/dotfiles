{ pkgs, ... }:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    buildInputs = with pkgs; [
      lix
      home-manager
      git
      sops
      ssh-to-age
      gnupg
      age
    ];
  };
}
