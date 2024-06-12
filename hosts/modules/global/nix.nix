{ lib, ... }:
{
  nix = {
    optimise.automatic = true;
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.lix.systems"
        "https://cache.nixos.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 5 generations
      options = "--delete-older-than +5";
    };
  };
}
