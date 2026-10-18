{ pkgs, config, ... }:
let
  inherit (config.networking) hostName;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.honnip = {
    isNormalUser = true;
    # Start user units at boot so that the SSH agent works
    # over SSH without a desktop login.
    linger = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ]
    ++ ifTheyExist [
      "network"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../../${hostName}/ssh_host_ed25519_key.pub)
      (builtins.readFile ../../../../home/honnip/ssh.pub)
      (builtins.readFile ../../../../home/honnip/id_ed25519.pub)
    ];
    hashedPasswordFile = config.sops.secrets.honnip-password.path;
  };

  programs.fish.enable = true;

  sops.secrets.honnip-password = {
    neededForUsers = true;
  };

  home-manager.users.honnip = import ../../../../home/honnip/${config.networking.hostName}.nix;
  home-manager.useGlobalPkgs = true;
}
