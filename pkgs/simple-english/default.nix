{
  src,
  lib,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "SimpleEnglish";
  version = "2.1.1";
  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r skills/simple-english $out
    runHook postInstall
  '';

  meta = {
    description = "Agent skill: make LLMs write docs in ASD-STE100 Simplified Technical";
    homepage = "https://AminBlg/SimpleEnglish";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.honnip ];
    platforms = lib.platforms.all;
  };

}
