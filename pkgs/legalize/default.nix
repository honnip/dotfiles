{
  lib,
  fetchFromGitHub,
  python3Packages,
  withMcp ? true,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "legalize-cli";
  version = "0.4.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "legalize-kr";
    repo = "cli-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XbojMQo+nNRYUyKkzjQuPl+BfRPNbzUhcLz44S8rhcE=";
  };

  build-system = [ python3Packages.hatchling ];
  dependencies =
    with python3Packages;
    [
      typer
      httpx
      pydantic
      pyyaml
      regex
      python-dateutil
    ]
    ++ lib.optional withMcp mcp;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-httpx
  ];

  disabledTestPaths = [ "tests/live" ];
  pythonImportsCheck = [ "legalize_cli" ] ++ lib.optional withMcp "legalize_cli.mcp_server";

  meta = {
    description = "CLI and MCP tools for querying Korean legal
data mirrored by legalize-kr";
    homepage = "https://github.com/legalize-kr/cli-tools";
    changelog = "https://github.com/legalize-kr/cli-tools/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "legalize";
    platforms = lib.platforms.unix;
  };
})
