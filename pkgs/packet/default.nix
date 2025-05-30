{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  cargo,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  protobuf,
  dbus,
  libadwaita,
  libsecret,
  tinysparql,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "packet";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nozwock";
    repo = "packet";
    tag = finalAttrs.version;
    hash = "sha256-wDndMoPPu5akimH8FTAZqYLrGKYkcx3G+DyPxY/lbRI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3Bq1ZKIrnj5/J9fFTBS6nB0rB1MTMTa57ZBQa4MdDtU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    protobuf
  ];

  buildInputs = [
    dbus
    libadwaita
    libsecret
    tinysparql
  ];

  meta = {
    description = "Quick Share client for Linux";
    homepage = "https://github.com/nozwock/packet";
    changelog = "https://github.com/nozwock/packet/releases/tag/${finalAttrs.version}";
    mainProgram = "packet";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.honnip ];
  };
})
