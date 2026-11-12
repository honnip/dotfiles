{
  lib,
  fetchurl,
  python3Packages,
}:
python3Packages.buildPythonPackage {
  pname = "hindsight-embed";
  # PyPI pin, not a flake input: version and hash move together.
  version = "0.10.3";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/f3/c4/4854a2e245937026dcdf3291506dc51b16dc9dcb9e673c8f6c4668d76632/hindsight_embed-0.10.3-py3-none-any.whl";
    hash = "sha256-KQuB2DY+mW8Wb1M9MsYec0r10QRpWiUrDg9ynPNuzPE=";
  };

  # Nothing propagates on purpose, same reason as pkgs/hindsight-client: the
  # hermes extraPythonPackages collision check rejects packages that its sealed
  # venv already ships. Runtime deps (aiohttp >=3.14.3, rich >=13) are in that
  # venv. nativeCheckInputs feeds the wheel metadata check and
  # pythonImportsCheck only.
  # Keep the version bound (>=0.10.1,<1) of the plugin's pyproject.toml.
  nativeCheckInputs = with python3Packages; [
    aiohttp
    rich
  ];
  pythonImportsCheck = [ "hindsight_embed" ];

  meta = {
    description = "Embedded Hindsight daemon manager for the hermes memory plugin";
    homepage = "https://github.com/vectorize-io/hindsight";
    license = lib.licenses.mit;
  };
}
