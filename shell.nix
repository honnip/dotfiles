{ pkgs, ... }: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    buildInputs = with pkgs; [ nix home-manager git sops ssh-to-age gnupg age ];
  };
}
