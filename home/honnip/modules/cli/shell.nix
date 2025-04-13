{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    plugins =
      let
        plugins = with pkgs.fishPlugins; [
          autopair
          async-prompt
        ];
      in
      builtins.map (pkg: {
        name = pkg.pname;
        src = pkg.src;
      }) plugins;
    functions = {
      _git_branch_name = {
        body = "fish_vcs_prompt";
      };
      _git_branch_name_loading_indicator = {
        body = "echo (set_color brblack)…(set_color normal)";
      };
      fish_prompt = {
        body = # fish
          ''
            function fish_prompt --description 'Write out the prompt'
              set -l last_pipestatus $pipestatus
              set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
              set -l normal (set_color normal)
              set -q fish_color_status
              or set -g fish_color_status red

              # Color the prompt differently when we're root
              set -l color_cwd $fish_color_cwd
              set -l suffix '>'
              if functions -q fish_is_root_user; and fish_is_root_user
                  if set -q fish_color_cwd_root
                      set color_cwd $fish_color_cwd_root
                  end
                  set suffix '#'
              end

              # Write pipestatus
              # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
              set -l bold_flag --bold
              set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
              if test $__fish_prompt_status_generation = $status_generation
                  set bold_flag
              end
              set __fish_prompt_status_generation $status_generation
              set -l status_color (set_color $fish_color_status)
              set -l statusb_color (set_color $bold_flag $fish_color_status)
              set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

              echo -n -s (prompt_login)' ' (set_color $color_cwd) (prompt_pwd) $normal (_git_branch_name) $normal " "$prompt_status $suffix " "
            end
          '';
      };
      fish_right_prompt = {
        body = "date '+%Y/%m/%d %H:%M:%S'";
      };
      tmp = {
        description = "Create and switch into an emphemeral directory";
        body = # fish
          ''
            # create a tmpdir and cd into it
            set -l tmp (mktemp --tmpdir -d tmpdir-XXXXXX)
            cd $tmp; and echo >&2 \
              (set_color yellow)"tmpdir:" $tmp "will be removed on exit" \
              (set_color normal)

            # spawn a new shell, store the exit status and return to previous dir
            fish $argv
            set -l ret $status
            cd $dirprev[-1]

            # after exit, check if there are mounts inside tmpdir
            if awk '{ print $2 }' /etc/mtab | grep $tmp
              echo >&2 \
                (set_color red)"refusing to purge $tmp due to mounts!" \
                (set_color normal)
            else
              # if clear, purge directory
              echo >&2 \
                (set_color red)"purge $tmp ..." \
                (set_color normal)
              rm -rf $tmp
            end

            # return subshell exit status
            return $ret
          '';
      };
      mkcd = {
        description = "Creates a directory then `cd` to it";
        body = # fish
          ''
            if test (count $argv) -eq 0
              echo "mkcd: missing directory operand"
              echo "Usage: mkcd DIRECTORY"
              return 1
            end
            mkdir -p "$argv[1]"; and cd "$argv[1]"
          '';
      };
    };
    interactiveShellInit = # fish
      ''
        set async_prompt_functions _git_branch_name
      '';
  };

  programs.eza.enable = lib.mkDefault true;
  programs.mcfly.enable = lib.mkDefault true;
}
