{
  config,
  inputs,
  ...
}:
let
  makeMachine =
    hostname:
    let
      config = inputs.self.outputs.nixosConfigurations.${hostname}.config;
    in
    {
      hostName = hostname;
      sshUser = "honnip";
      systems = [ config.nixpkgs.hostPlatform.system ];
      maxJobs = config.nix.settings.max-jobs;
      supportedFeatures = config.nix.settings.system-features;
    };

  hostname = config.networking.hostName;
  machineNames = builtins.filter (n: n != hostname && n != "canopus") (
    builtins.attrNames inputs.self.outputs.nixosConfigurations
  );
in
{
  nix = {
    distributedBuilds = true;
    buildMachines = builtins.map (n: makeMachine n) machineNames;
  };
}
