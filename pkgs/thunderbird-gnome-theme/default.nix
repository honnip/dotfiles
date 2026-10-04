{
  lib,
  stdenvNoCC,
  src,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderbird-gnome-theme";
  version = "unstable";

  inherit src;

  dontBuild = true;

  installPhase = "cp -r . $out";

  meta = {
    description = "GNOME theme for Thunderbird";
    homepage = "https://github.com/rafaelmardojai/thunderbird-gnome-theme";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.honnip ];
    platforms = lib.platforms.all;
  };
}
