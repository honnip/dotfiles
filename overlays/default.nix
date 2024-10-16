{ inputs, outputs, ... }:
{
  nixpkgs-review-lix = final: prev: {
    nixpkgs-review = prev.nixpkgs-review.override {
      nix = final.lix;
      withNom = true;
    };
  };

  additions =
    final: prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
}
