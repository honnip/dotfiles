{ osConfig, config, ... }:
{
  programs.git = {
    enable = true;
    package = osConfig.programs.git.package;
    userName = "Honnip";
    userEmail = "me@honnip.page";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      gpg.program = "${config.programs.gpg.package}/bin/gpg2";
      user = {
        signing.key = "576E43EF8482E415";
      };
      core = {
        editor = "hx";
        quotepath = false;
      };
      color = {
        ui = "auto";
      };
      commit = {
        gpgsign = true;
        verbose = true;
      };
      push = {
        default = "current";
      };
      pull = {
        rebase = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      diff = {
        algorithm = "histogram";
      };
      tag = {
        gpgsign = true;
        sort = "taggerdate";
      };
      branch = {
        sort = "committerdate";
      };

      # autocorrect typo
      help.autocorrect = "immediate";

      # autosolve repetitive conflicts
      rerere.enable = true;

      # fsck
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;

      # iso8601 date format
      log.date = "iso";

      "url" = {
        "git@github.com:" = {
          insteadOf = "gh:";
          pushInsteadOf = "https://github.com/";
        };
        "git@gitlab.com:" = {
          insteadOf = "gl:";
          pushInsteadOf = "https://gitlab.com/";
        };
        "git@ssh.gitlab.gnome.org:" = {
          insteadOf = "gnome:";
          pushInsteadOf = "https://gitlab.gnome.org/";
        };
      };
    };
    difftastic.enable = true;
    ignores = [
      ".direnv"
      ".envrc"
      "result"
    ];
  };
}
