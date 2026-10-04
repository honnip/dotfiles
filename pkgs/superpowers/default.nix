{ stdenvNoCC, src, ... }:
stdenvNoCC.mkDerivation {
  pname = "superpowers";
  version = "6.4.2";
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
