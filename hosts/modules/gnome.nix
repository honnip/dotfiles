{ pkgs, ... }:
{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-tour
      geary # email client
      yelp # help view
      tali # pocker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      evince # replaced by papers
      totem # video player
    ]
  );

  environment.systemPackages = with pkgs; [
    hunspellDicts.en_US
    hunspellDicts.ko_KR

    papers
    ptyxis
    showtime
  ];

  i18n = {
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };
}
