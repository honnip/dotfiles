{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
    iosevka
    ibm-plex
    pretendard
  ];
}
