{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.lix-module.nixosModules.lixFromNixpkgs
    inputs.home-manager.nixosModules.home-manager
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./sops.nix
    ./systemd-initrd.nix
    ./tailscale.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  boot.tmp.cleanOnBoot = lib.mkDefault true;

  services.dbus.implementation = "broker";

  programs.git.package = lib.mkDefault pkgs.gitMinimal;

  system.stateVersion = "24.11";
}
