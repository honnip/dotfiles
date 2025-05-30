{ inputs, pkgs, ... }:
{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  environment.systemPackages = [ pkgs.lix-diff ];
  nix.settings.experimental-features = [ "lix-custom-sub-commands" ];
}
