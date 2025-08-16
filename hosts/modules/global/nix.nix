{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.lix-module.nixosModules.lixFromNixpkgs ];
  nix = {
    channel.enable = false;
    # the store is host-managed
    optimise.automatic = lib.mkDefault (!config.boot.isContainer);
    settings = {
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
