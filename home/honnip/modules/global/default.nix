{
  inputs,
  config,
  outputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  home = {
    username = "honnip";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.11";
  };

  xdg.userDirs = {
    enable = lib.mkDefault true;
    createDirectories = true;
  };
}
