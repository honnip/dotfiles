{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };

  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-tour
      geary # email reader
      yelp # help view
      tali # pocker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      evince # replaced by papers
    ]
  );

  environment.systemPackages = with pkgs; [
    hunspellDicts.en_US
    hunspellDicts.ko_KR
  ];

  i18n = {
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };
}
