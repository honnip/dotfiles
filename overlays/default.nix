{ inputs, outputs, ... }:
{
  modifications = (
    final: prev: {
      gnome = prev.gnome.overrideScope' (
        gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (old: {
            src = final.fetchgit {
              url = "https://gitlab.gnome.org/vanvugt/mutter.git";
              # GNOME 46: triple-buffering-v4-46
              rev = "663f19bc02c1b4e3d1a67b4ad72d644f9b9d6970";
              sha256 = "sha256-I1s4yz5JEWJY65g+dgprchwZuPGP9djgYXrMMxDQGrs=";
            };
            patches = (old.patches or [ ]) ++ [
              # text-input-v1 support
              (prev.fetchpatch {
                url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3751/diffs.patch";
                hash = "sha256-fuyR+FfPHYGDwyGZ8zzIahqKlQFyguYCc4qQ/iGcizM=";
              })
            ];
          });
        }
      );
    }
  );

  additions =
    final: prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
}
