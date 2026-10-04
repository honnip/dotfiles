{
  stdenvNoCC,
  src,
  lib,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "legalize-skills";
  version = "0.1.1";
  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r skills/legalize-kr $out
    runHook postInstall
  '';

  meta = {
    description = "AI Agent를 위한 스킬 및 플러그인 - legalize-kr의 한국 법령·판례·행정규칙·자치법규 조회 및 활용";
    homepage = "https://legalize.kr";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.honnip ];
    platforms = lib.platforms.all;
  };
}
