{
  lib,
  fetchurl,
  python3Packages,
}:
python3Packages.buildPythonPackage {
  pname = "hindsight-client";
  # PyPI pin, not a flake input: version and hash move together.
  version = "0.10.3";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/54/31/5157bd9f73dca7ef2516470ff85818e03d6167f031cfcc96ff1c263ebc12/hindsight_client-0.10.3-py3-none-any.whl";
    hash = "sha256-tNDRu8KdzU7yWkojoIpIBG1TN7cEva+rsC0AENKZoGg=";
  };

  # Nothing propagates on purpose. This package feeds
  # services.hermes-agent.extraPythonPackages, and the hermes build rejects any
  # package that already exists in its sealed venv. Every runtime dependency
  # (aiohttp, pydantic, python-dateutil, typing-extensions, urllib3, yarl) is
  # in that venv already. Only aiohttp-retry is missing and it is added as its
  # own extraPythonPackages entry. nativeCheckInputs feeds the wheel metadata
  # check and pythonImportsCheck only; nothing propagates past this derivation.
  # Keep the version bound (>=0.10.1,<1) of the plugin's pyproject.toml.
  nativeCheckInputs = with python3Packages; [
    aiohttp
    aiohttp-retry
    pydantic
    python-dateutil
    typing-extensions
    urllib3
    yarl
  ];
  pythonImportsCheck = [ "hindsight_client" ];

  meta = {
    description = "Python client for the Hindsight memory API";
    homepage = "https://github.com/vectorize-io/hindsight";
    license = lib.licenses.mit;
  };
}
