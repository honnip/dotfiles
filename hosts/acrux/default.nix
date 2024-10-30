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

    ../modules/font.nix
    ../modules/quietboot.nix
    ../modules/gnome.nix
    ../modules/printer.nix
    ../modules/pipewire.nix
    ../modules/appimage.nix
  ];

  networking.hostName = "acrux";

  networking.firewall.allowedTCPPorts = [ 46431 ];
  networking.firewall.allowedUDPPorts = [ 46431 ];

  services.nixseparatedebuginfod.enable = true;

  system.switch = {
    enable = false;
    enableNg = true;
  };

  system.stateVersion = "24.05";
}
