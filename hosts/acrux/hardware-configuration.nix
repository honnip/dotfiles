{ inputs, pkgs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ./disko.nix ];

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

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
