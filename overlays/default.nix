{ inputs, ... }:
{
  additions =
    final: prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };

  downgrade-spiectify = final: prev: {
    spicetify-cli = prev.spicetify-cli.overrideAttrs (old: {
      version = "2.43.2";
      src = prev.fetchFromGitHub {
        owner = "spicetify";
        repo = "cli";
        tag = "v2.43.2";
        hash = "sha256-77OZVDtybkYI5R3tZ7q2cLJ+Ixn8WB4CP4qP6Yp535g=";
      };
      vendorHash = "sha256-uuvlu5yocqnDh6OO5a4Ngp5SahqURc/14fcg1Kr9sec=";
    });
  };
}
