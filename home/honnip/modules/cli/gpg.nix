{ pkgs, osConfig, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = osConfig.programs.gnupg.agent.pinentryPackage;
    sshKeys = [ "2D2EE524704A372F2A78883F60512F0793EABAF5" ];
    enableExtraSocket = true;
  };

  programs.gpg = {
    enable = true;
    settings = {
      trust-model = "tofu+pgp";
    };
    publicKeys = [
      {
        source = ../../public.asc;
        trust = 5;
      }
    ];
  };

  systemd.user.services = {
    # Link /run/user/$UID/gnupg to ~/.gnupg-sockets
    # So that SSH config does not have to know the UID
    link-gnupg-sockets = {
      Unit = {
        Description = "link gnupg sockets from /run to /home";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-sockets";
        ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
        RemainAfterExit = true;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
