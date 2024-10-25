{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    iosevka
    ibm-plex
    pretendard
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
