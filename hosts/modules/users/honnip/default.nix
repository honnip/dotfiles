{ pkgs, config, ... }:
let
  inherit (config.networking) hostName;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.honnip = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups =
      [
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
    ];
    hashedPasswordFile = config.sops.secrets.honnip-password.path;
    packages = with pkgs; [ home-manager ];
  };

  sops.secrets.honnip-password = {
    neededForUsers = true;
  };

  home-manager.users.honnip = import ../../../../home/honnip/${config.networking.hostName}.nix;
}
