{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports = [ inputs.disko.nixosModules.disko ./disko.nix ];

  # TODO
  # imports = [ ../modules/ephemeral-btrfs.nix ../modules/encrypted-root.nix ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-amd" ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/bd869d0c-b482-4012-87e4-263c0d0be9d8";
  #   fsType = "btrfs";
  #   options = [ "subvol=@root" "compress=zstd" ];
  # };

  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-uuid/bd869d0c-b482-4012-87e4-263c0d0be9d8";
  #   fsType = "btrfs";
  #   options = [ "subvol=@nix" "compress=zstd" ];
  # };

  # fileSystems."/home" = {
  #   device = "/dev/disk/by-uuid/bd869d0c-b482-4012-87e4-263c0d0be9d8";
  #   fsType = "btrfs";
  #   options = [ "subvol=@home" "compress=zstd" ];
  # };

  # fileSystems."/swap" = {
  #   device = "/dev/disk/by-uuid/bd869d0c-b482-4012-87e4-263c0d0be9d8";
  #   fsType = "btrfs";
  #   options = [ "subvol=@swap" "noatime" ];
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/0BC0-C3C9";
  #   fsType = "vfat";
  # };

  # swapDevices = [{
  #   device = "/swap/swapfile";
  #   options = [ "subvol=@swap" "noatime" ];
  # }];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
