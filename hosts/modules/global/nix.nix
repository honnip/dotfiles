{ lib, pkgs, ... }:
{
  nix = {
    package = pkgs.lix;
    optimise.automatic = true;
    settings = {
      trusted-users = [ "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.lix.systems"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
