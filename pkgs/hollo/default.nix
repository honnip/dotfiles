{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  pkg-config,
  vips,
  python3,
  node-gyp,
  nodejs, srcOnly,
  ffmpeg-headless,
  makeBinaryWrapper,
}:
let
  version = "0.1.5";

  deps = {
    "x86_64-linux" = "sha256-eImsDk3rZdNZkiw+WHk4JozxWS+Rhf7CAgL1L25zucU=";
    "aarch64-linux" = "sha256-jar8WNcqsXC8+O9HpWsKJ9uDNPei2jpJkusInPJiMYA=";
  };

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hollo";
    rev = "refs/tags/${version}";
    hash = "sha256-QpAtuMVkA9kzgvXGEEGmHQdzncbkjOA/MpL6PIJJAzM=";
  };

  node-addon-api = stdenv.mkDerivation rec {
    pname = "node-addon-api";
    version = "8.0.0";
    src = fetchFromGitHub {
      owner = "nodejs";
      repo = "node-addon-api";
      rev = "v${version}";
      hash = "sha256-k3v8lK7uaEJvcaj1sucTjFZ6+i5A6w/0Uj9rYlPhjCE=";
    };
    installPhase = ''
      mkdir $out
      cp -r *.c *.h *.gyp *.gypi index.js package-support.json package.json tools $out/
    '';
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

    preBuild = ''
      pushd node_modules/sharp

      mkdir node_modules
      ln -s ${node-addon-api} node_modules/node-addon-api

      ${lib.getExe nodejs} install/check

      rm -r node_modules

      popd
      rm -r node_modules/@img/sharp*
    '';

    buildPhase = ''
      bun install --no-progress --frozen-lockfile
    '';

    installPhase = ''
      mkdir -p $out/node_modules
      cp -r ./node_modules $out
    '';

    outputHash = deps.${stdenv.system};
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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]} \
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
