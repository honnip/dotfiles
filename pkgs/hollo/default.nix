{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  ffmpeg-headless,
  makeBinaryWrapper,
}:
let
  version = "0.2.1";

  deps = {
    "x86_64-linux" = "sha256-Tw+A6RTnpwQFYYmQ4PeeMe5dWJRXbPH9+VC+qzy2jKk=";
    "aarch64-linux" = "sha256-qKmkW+Pj3wPJwnyNor9J2kqxOR58JFxFmCDT5vMF0ss=";
  };

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hollo";
    rev = "refs/tags/${version}";
    hash = "sha256-vAzb1wDxaw6VHCq9Yxxk4imUIyBs5vIsoX0/SKthDPw=";
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
    dontFixup = true;

    buildPhase = ''
      bun install --no-progress --frozen-lockfile --no-cache
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

  dontConfigure = true;
  dontBuild = true;

  # TODO: remove when https://github.com/dahlia/hollo/issues/56 is resolved
  patches = [
    ./db-connection.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out
    cp -r ./* $out

    makeBinaryWrapper ${bun}/bin/bun $out/bin/hollo \
      --prefix PATH : ${
        lib.makeBinPath [
          bun
          ffmpeg-headless
        ]
      } \
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
