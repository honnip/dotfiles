{ inputs, pkgs, ... }:
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
    ../modules/syncthing.nix
    ../modules/remote-build.nix
    ../modules/lix.nix
  ];

  networking.hostName = "acrux";
  networking.firewall.allowedTCPPorts = [ 9300 ];
  networking.firewall.allowedUDPPorts = [ 9300 ];

  environment.systemPackages = with pkgs; [ nautilus-python ];
  environment.pathsToLink = [ "/share/nautilus-python/extensions" ];

  services.nixseparatedebuginfod.enable = true;

  nix.settings.max-jobs = 10;
}
