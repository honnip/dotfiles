{ inputs, ... }:
{
  imports = [
    inputs.lix-module.nixosModules.default
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
    ../modules/syncthing.nix
    ../modules/remote-build.nix
  ];

  networking.hostName = "acrux";

  networking.firewall.allowedTCPPorts = [ 46431 ];
  networking.firewall.allowedUDPPorts = [ 46431 ];

  services.nixseparatedebuginfod.enable = true;

  system.switch = {
    enable = false;
    enableNg = true;
  };

  nix.settings.max-jobs = 10;
}
