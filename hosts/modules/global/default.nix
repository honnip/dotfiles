{ inputs, outputs, ... }:
{
  imports = [
    inputs.lix-module.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    ./locale.nix
    ./font.nix
    ./nix.nix
    ./openssh.nix
    ./fish.nix
    ./sops.nix
    ./systemd-initrd.nix
    ./tailscale.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  hardware.enableRedistributableFirmware = true;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  services.dbus.implementation = "broker";
}
