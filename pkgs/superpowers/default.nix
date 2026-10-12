{ stdenvNoCC, src, ... }:
stdenvNoCC.mkDerivation {
  pname = "superpowers";
  version = "7.0.0";
  inherit src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    cp -r .hermes-plugin $out
    cp -r skills $out/skills
    runHook postInstall
  '';
}
