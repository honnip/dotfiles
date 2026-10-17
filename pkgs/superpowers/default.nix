{
  stdenvNoCC,
  src,
  version,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "superpowers";
  inherit version;
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
