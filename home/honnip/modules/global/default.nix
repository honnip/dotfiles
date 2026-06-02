{
  inputs,
  config,
  outputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  systemd.user.startServices = "sd-switch";

  home = {
    username = "honnip";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "26.05";
  };

  xdg.userDirs = {
    enable = lib.mkDefault true;
    createDirectories = true;
  };
}
