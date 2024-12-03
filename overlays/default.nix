{ inputs, ... }:
{
  nixpkgs-review-lix = final: prev: {
    nixpkgs-review = prev.nixpkgs-review.override {
      nix = final.lix;
      withNom = true;
    };
  };

  mutter-wayland-fix = final: prev: {
    mutter = prev.mutter.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (final.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/60098ed2c7a578202e34b9b19540b0b3da120368.diff";
          hash = "sha256-5Xpjamtbvr+lb/5jv8uudxJUnxz6AQGuQr9HJFF3E+Y=";
        })
      ];
    });
  };

  obsidian-wayland =
    final: prev:
    let
      flags = "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
    in
    {
      obsidian = final.symlinkJoin {
        name = prev.obsidian.name;
        paths = [
          prev.obsidian
        ];
        buildInputs = [ prev.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/obsidian --add-flags "${flags}"
        '';
      };
    };

  bump-pano = final: prev: {
    gnomeExtensions = prev.gnomeExtensions // {
      pano = prev.gnomeExtensions.pano.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "v23-alpha3";
          src = prev.fetchzip {
            url = "https://github.com/oae/gnome-shell-pano/releases/download/${finalAttrs.version}/pano@elhan.io.zip";
            hash = "sha256-LYpxsl/PC8hwz0ZdH5cDdSZPRmkniBPUCqHQxB4KNhc=";
            stripRoot = false;
          };
          # patch is outdated
          patches = [ ];
          preInstall = ''
            substituteInPlace extension.js \
              --replace-warn "import Gda from 'gi://Gda?version>=5.0'" "imports.gi.GIRepository.Repository.prepend_search_path('${final.libgda}/lib/girepository-1.0'); const Gda = (await import('gi://Gda')).default" \
              --replace-warn "import GSound from 'gi://GSound'" "imports.gi.GIRepository.Repository.prepend_search_path('${final.gsound}/lib/girepository-1.0'); const GSound = (await import('gi://GSound')).default"
          '';
        }
      );
    };
  };

  additions =
    final: prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
}
