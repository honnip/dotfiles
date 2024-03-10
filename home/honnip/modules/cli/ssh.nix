{ outputs, config, ... }:
let hostnames = builtins.attrNames outputs.nixosConfigurations;
in {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      net = {
        host = builtins.concatStringsSep " " hostnames;
        forwardAgent = true;
        remoteForwards = [{
          bind.address = "/%d/.gnupg-sockets/S.gpg-agent";
          host.address = "/%d/.gnupg-sockets/S.gpg-agnet.extra";
        }];
      };
    };
  };

  # home.persistence = {
  #   "/persist/home/${config.home.username}".directories = [ ".ssh" ];
  # };
}
