{ inputs, ... }:
{
  nixpkgs-review-lix = final: prev: {
    nixpkgs-review = prev.nixpkgs-review.override {
      nix = final.lix;
      git = final.gitMinimal;
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

  additions =
    final: prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
}
