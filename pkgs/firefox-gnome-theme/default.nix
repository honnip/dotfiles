{
  lib,
  stdenvNoCC,
  src,
}:

stdenvNoCC.mkDerivation {
  pname = "firefox-gnome-theme";
  version = "unstable";

  inherit src;

  dontBuild = true;

  installPhase = "cp -r . $out";

  meta = {
    description = "GNOME theme for Firefox";
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.honnip ];
    platforms = lib.platforms.all;
  };
}
