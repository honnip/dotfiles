# aiohttp-retry for services.hermes-agent.extraPythonPackages, with propagation
# removed. The hermes build refuses any extra package that its sealed venv
# already ships, and aiohttp is in that venv (it comes with the matrix extra),
# so the plain nixpkgs attribute would fail the collision check. At runtime the
# plugin imports aiohttp from the sealed venv.
{ python3Packages }:
python3Packages.aiohttp-retry.overridePythonAttrs (old: {
  # aiohttp stays a build/check input only: propagating it would trip the
  # hermes collision check. The upstream tests and the wheel metadata check
  # still see it here.
  dependencies = [ ];
  propagatedBuildInputs = [ ];
  nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [ python3Packages.aiohttp ];
})
