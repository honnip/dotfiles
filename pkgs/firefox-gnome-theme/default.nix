{ lib, stdenv, src }:

stdenv.mkDerivation {
  pname = "firefox-gnome-theme";
  version = "unstable";

  inherit src;

  dontBuild = true;

  installPhase = "cp -r . $out";

  meta = with lib; {
    description = "GNOME theme for Firefox";
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    license = licenses.unlicense;
    maintainers = with maintainers; [ honnip ];
    platforms = platforms.all;
  };
}
