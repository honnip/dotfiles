{
  config,
  lib,
  ...
}:
{
  environment = {
    variables.BROWSER = "echo";
    stub-ld.enable = lib.mkDefault false;
  };

  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 5;

  fonts.fontconfig.enable = lib.mkDefault false;

  programs.command-not-found.enable = lib.mkDefault false;

  xdg.autostart.enable = lib.mkDefault false;
  xdg.icons.enable = lib.mkDefault false;
  xdg.menus.enable = lib.mkDefault false;
  xdg.mime.enable = lib.mkDefault false;
  xdg.sounds.enable = lib.mkDefault false;

  # emergency mode is useless as the system is headless
  systemd.enableEmergencyMode = false;
  boot.initrd.systemd.suppressedUnits = lib.mkIf config.systemd.enableEmergencyMode [
    "emergency.service"
    "emergency.target"
  ];
}
