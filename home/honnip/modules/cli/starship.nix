{
  programs.starship = {
    enable = true;
    settings = {
      format =
        let
          git = "$git_branch$git_commit$git_state$git_status";
        in
        ''
          $username$hostname($shlvl)($cmd_duration) $fill ($nix_shell)
          $directory(${git}) $fill $time
          $jobs$character
        '';
      fill = {
        symbol = " ";
        disabled = false;
      };
      username = {
        format = "[$user]($style)";
        show_always = true;
      };
      hostname = {
        format = "[@$hostname]($style) ";
        ssh_only = false;
        style = "bold green";
      };
      shlvl = {
        format = "[$shlvl]($style) ";
        style = "bold cyan";
        threshold = 2;
        repeat = true;
        disabled = false;
      };
      cmd_duration = {
        format = "took [$duration]($style) ";
      };
      directory = {
        format = "[$path]($style)( [$read_only]($read_only_style)) ";
      };
      nix_shell = {
        format = "[($name \\(develop\\) <- )$symbol]($style) ";
        impure_msg = "";
        symbol = " ";
        style = "bold red";
      };
      character = {
        error_symbol = "[~~>](bold red)";
        success_symbol = "[->>](bold green)";
      };
    };
  };
}
