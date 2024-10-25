{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  ffmpeg-headless,
  makeBinaryWrapper,
}:
let
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hollo";
    rev = "refs/tags/${version}";
    hash = "sha256-BL3SLfmrgF3h/CJupSf6Ul80x2gUZWbSnUUjBjhrUkY=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "hollo-deps";
    version = version;
    inherit src;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    buildPhase = ''
      bun install --no-progress --frozen-lockfile
    '';

    installPhase = ''
      mkdir -p $out/node_modules
      cp -R ./node_modules $out
    '';

    outputHash = "sha256-qdJ65piKwvMNLQpT9XfZeTKo/6+cgZR9zasXvzk9JS0=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "hollo";
  inherit version src;
  nativeBuildInputs = [ makeBinaryWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out
    cp -R ./* $out

    makeBinaryWrapper ${bun}/bin/bun $out/bin/hollo \
      --prefix PATH : ${lib.makeBinPath [ bun ffmpeg-headless ]} \
      --add-flags "run --prefer-offline --no-install --cwd $out prod"

    runHook postInstall
  '';

  meta = {
    homepage = "https://docs.hollo.social";
    changelog = "https://github.com/dahlia/hollo/releases/tag/${version}";
    description = "Federated single-user microblogging software";
    mainProgram = "hollo";
    maintainers = [ lib.maintainers.honnip ];
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
