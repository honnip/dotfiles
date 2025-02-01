{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs_23,
  pnpm_9,
  ffmpeg-headless,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hollo";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hollo";
    tag = finalAttrs.version;
    hash = "sha256-/UiHMYA+Y4FVmkZf1e6OMwGW+i1EuWwVUFizWsB5PAU=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs_23
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-XYvOec8Lb3HlEeuI7U34nwDijoaVFw5RuD8S5bgJSS0=";
  };

  # TODO: remove when https://github.com/dahlia/hollo/issues/56 is resolved
  patches = [
    ./db-connection.patch
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    makeBinaryWrapper ${lib.getExe pnpm_9} $out/bin/hollo \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs_23
          pnpm_9
          ffmpeg-headless
        ]
      } \
      --add-flags "run --dir $out prod"

    runHook postInstall
  '';

  meta = {
    homepage = "https://docs.hollo.social";
    changelog = "https://github.com/dahlia/hollo/releases/tag/${finalAttrs.version}";
    description = "Federated single-user microblogging software";
    mainProgram = "hollo";
    maintainers = [ lib.maintainers.honnip ];
    license = lib.licenses.agpl3Only;
    platforms = nodejs_23.meta.platforms;
  };
})
