{
  programs.bat = {
    enable = true;
    config.theme = "base16";
  };

  systemd.user.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };
}
