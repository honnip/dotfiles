{
  lib,
  stdenv,
  src,
}:

stdenv.mkDerivation {
  pname = "thunderbird-gnome-theme";
  version = "unstable";

  inherit src;

  dontBuild = true;

  installPhase = "cp -r . $out";

  meta = with lib; {
    description = "GNOME theme for Thunderbird";
    homepage = "https://github.com/rafaelmardojai/thunderbird-gnome-theme";
    license = licenses.unlicense;
    maintainers = with maintainers; [ honnip ];
    platforms = platforms.all;
  };
}
