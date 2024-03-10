{ lib, stdenv, src }:

stdenv.mkDerivation {
  pname = "firefox-gnome-theme";
  version = "unstable";

  inherit src;

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/share/firefox-gnome-theme
    cp -r theme/* $out/share/firefox-gnome-theme
  '';

  meta = with lib; {
    description = "GNOME theme for Firefox";
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    maintainers = with maintainers; [ honnip ];
    platforms = platforms.all;
  };
}
