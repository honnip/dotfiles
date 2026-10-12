{
  src,
  lib,
  stdenvNoCC,
  version,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "humanizer";
  inherit version;
  inherit src;

  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Agent skill that removes signs of AI-generated writing from text";
    homepage = "https://github.com/blader/humanizer";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.honnip ];
    platforms = lib.platforms.all;
  };
}
