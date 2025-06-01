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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "packet";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nozwock";
    repo = "packet";
    tag = finalAttrs.version;
    hash = "sha256-Bk2J38NNrfixkYMveNQb9KkNG/pF3V9LgD1YGgmxg1c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZoL8N407G7U5VQwDbQSgMv96mSHAeytL6qJ1iR9LvkM=";
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
