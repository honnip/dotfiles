{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  ffmpeg-headless,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hollo";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "fedify-dev";
    repo = "hollo";
    tag = finalAttrs.version;
    hash = "sha256-ia+IuZp7UYPEX4DIywFhjl6h3E95mZyZkMIZo645r5Q=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-vVyH0CylswMchkRFCy6P8TTFKaaIGco/nz8WEOmXl4I=";
  };

  # TODO: remove when https://github.com/dahlia/hollo/issues/56 is resolved
  patches = [
    ./db-connection.patch
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    echo "shell-emulator=true" > $out/.npmrc
    makeBinaryWrapper ${lib.getExe pnpm_9} $out/bin/hollo \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
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
    license = lib.licenses.agpl3Plus;
    platforms = nodejs.meta.platforms;
  };
})
