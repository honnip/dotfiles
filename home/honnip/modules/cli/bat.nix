{
  programs.bat = {
    enable = true;
    config.theme = "base16";
  };

  systemd.user.sessionVariables = {
    MANROFFOPT = "-c";
    MANPAGER = "sh -c 'col -bx | bat -plman --theme \"Monokai Extended\"'";
  };
}
