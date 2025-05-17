{ inputs, ... }:
{
  nixpkgs-review = final: prev: {
    nixpkgs-review = prev.nixpkgs-review.override {
      git = final.gitMinimal;
      withNom = true;
    };
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
