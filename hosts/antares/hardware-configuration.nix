{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "virtio_pci"
      "virtio_scsi"
      "usbhid"
    ];

    # Load graphics driver in stage 1
    # initrd.kernelModules = [ "bochs_drm" ];

    # Copied from Ubuntu config
    kernelParams = [
      "console=ttyS0"
      "console=tty1"
      "nvme.shutdown_timeout=10"
      "libiscsi.debug_libiscsi_eh=1"
    ];

    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
