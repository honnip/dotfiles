{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "superpowers";
  version = "6.4.1";
  src = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v6.4.1";
    hash = "sha256-rgeJhjQyABYlhlyFRmgyhbZmmmIPPNkch4CXyTkGEyM=";
  };
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r .hermes-plugin/. $out/
    cp -r skills $out/skills
    runHook postInstall
  '';
}
