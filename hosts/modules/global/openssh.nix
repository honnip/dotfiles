{ outputs, lib, config, ... }:

let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
  gitHost = hosts."acrux".config.networking.hostName;

  # hasOptinPersistence = config.environment.persistence ? "/persist";
  hasOptinPersistence = false;
in {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
    };

    # generate SSH host keys
    hostKeys = [{
      path = "${
          lib.optionalString hasOptinPersistence "/persist"
        }/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    knownHosts = builtins.mapAttrs (name: _: {
      publicKeyFile = pubKey name;
      extraHostNames = (lib.optional (name == hostName) "localhost")
        ++ (lib.optionals (name == gitHost) [
          "honnip.page"
          "git.honnip.page"
        ]);
    }) hosts;
  };

  # Skip the password prompt when SSH'ing with keys
  security.pam.sshAgentAuth = {
    enable = true;
    authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
  };
}
