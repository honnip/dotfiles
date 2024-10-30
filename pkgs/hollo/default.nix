{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  pkg-config,
  vips,
  python3,
  node-gyp,
  ffmpeg-headless,
  makeBinaryWrapper,
}:
let
  version = "0.1.4";

  deps = {
    "x86_64-linux" = "sha256-3ks0rZIvb2+wnRjhdFnochrDUzeyAYKZa4SeaNsO/lQ=";
    "aarch64-linux" = "sha256-jar8WNcqsXC8+O9HpWsKJ9uDNPei2jpJkusInPJiMYA=";
  };

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hollo";
    rev = "refs/tags/${version}";
    hash = "sha256-6YJGEDSX+FZO3744E24ZxZSgd0fX7cPO33fmKOrXugQ=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "hollo-deps";
    version = version;
    inherit src;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      pkg-config
      python3
      node-gyp
    ];
    buildInputs = [ vips ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      bun install --no-progress --frozen-lockfile
      # pushd node_modules/sharp
      # bun install --no-progress --frozen-lockfile
      # popd
    '';

    installPhase = ''
      mkdir -p $out/node_modules
      cp -r ./node_modules $out
    '';

    outputHash = deps."${stdenv.system}";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "hollo";
  inherit version src;
  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ ffmpeg-headless ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out
    cp -r ./* $out

    makeBinaryWrapper ${bun}/bin/bun $out/bin/hollo \
      --prefix PATH : ${lib.makeBinPath [ bun ]} \
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
