{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../modules/global
    ../modules/users/honnip

    ../modules/quietboot.nix
    ../modules/gnome.nix
    ../modules/flatpak.nix
    ../modules/printer.nix
    ../modules/pipewire.nix
    ../modules/appimage.nix
    ../modules/tmpfs.nix
  ];

  networking = {
    hostName = "acrux";
  };

  system.stateVersion = "24.05";
}
