{ inputs, outputs, ... }:
{
  modifications = (
    final: prev: {
      wayland-protocols-136 = prev.wayland-protocols.overrideAttrs (old: {
        src = final.fetchurl {
          url = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.36/downloads/wayland-protocols-1.36.tar.xz";
          hash = "sha256-cf1N4F55+aHKVZ+sMMH4Nl+hA0ZCL5/nlfdNd7nvfpI=";
        };
      });
      gnome = prev.gnome.overrideScope (
        gnomeFinal: gnomePrev: {
          mutter =
            (gnomePrev.mutter.overrideAttrs (old: {
              src = final.fetchgit {
                url = "https://gitlab.gnome.org/GNOME/mutter.git";
                rev = "2f8a598582bd2473d8449d7a7e549a43c6e55243";
                sha256 = "sha256-tO+lrSfDbbi9/wGzH98I83P+EioZRwURSrLru9YbkyY=";
              };
              patches = (old.patches or [ ]) ++ [
                # text-input-v1 support
                (prev.fetchpatch {
                  # url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3751/diffs.patch";
                  url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3751/diffs.patch?diff_id=1117998";
                  hash = "sha256-KOpYon8Ajzn60voOAnj6wqXxZ7nnnJ9RIPhjGBKS5uY=";
                })
              ];
            })).override
              { wayland-protocols = final.wayland-protocols-136; };
        }
      );
    }
  );

  wayland = (
    final: prev: {
      discord = final.symlinkJoin {
        name = prev.discord.name;
        paths = [
          (prev.discord.override {
            withOpenASAR = true;
            withVencord = true;
          })
        ];
        buildInputs = [ final.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/discord --add-flags "--ozone-platform=wayland --enable-wayland-ime"
          wrapProgram $out/bin/Discord --add-flags "--ozone-platform=wayland --enable-wayland-ime"
        '';
      };

      vscode = final.symlinkJoin {
        name = prev.vscode.name;
        paths = [ prev.vscode ];
        buildInputs = [ final.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/code --add-flags "--ozone-platform=wayland --enable-wayland-ime"
        '';
      };

      obsidian = final.symlinkJoin {
        name = prev.obsidian.name;
        paths = [ prev.obsidian ];
        buildInputs = [ final.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/obsidian --add-flags "--ozone-platform=wayland --enable-wayland-ime"
        '';
      };
    }
  );

  additions =
    final: prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
}
