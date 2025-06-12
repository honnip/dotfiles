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
  appstream,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "packet";
  version = "0.5.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nozwock";
    repo = "packet";
    tag = finalAttrs.version;
    hash = "sha256-MZdZf4fLtUd30LncPLVkcNdjuzw+Wi33A1MJqQbEurk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ODrM8oGQpi+DpG4YQYibtVHbicuHOjZAlZ1wW2Gulec=";
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
    appstream
  ];

  buildInputs = [
    dbus
    libadwaita
    python3Packages.wrapPython
  ];

  postFixup = ''
    buildPythonPath ${python3Packages.dbus-python}
    patchPythonScript $out/share/packet/plugins/packet_nautilus.py
    mkdir -p $out/share/nautilus-python
    ln -s $out/share/packet/plugins $out/share/nautilus-python/extensions
  '';

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
