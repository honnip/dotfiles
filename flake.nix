{
  description = "NixOS configuration";

  nixConfig.allow-import-from-derivation = false;

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/86621d45826059b3b4e96742fb25bfe234e475d7";
    hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    thunderbird-gnome-theme = {
      url = "github:rafaelmardojai/thunderbird-gnome-theme";
      flake = false;
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes = {
      url = "github:NousResearch/hermes-agent?ref=v0.22.5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    legalize-cli = {
      url = "github:legalize-kr/cli-tools?ref=v0.5.3";
      flake = false;
    };
    legalize-skills = {
      url = "github:legalize-kr/agent-skills?&ref=v0.2.4";
      flake = false;
    };
    superpowers = {
      url = "github:obra/superpowers?ref=v7.0.0";
      flake = false;
    };
    humanizer = {
      url = "github:blader/humanizer?ref=v3.1.0";
      flake = false;
    };
    simple-english = {
      url = "github:AminBlg/SimpleEnglish?ref=v2.1.1";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      pkgsFor = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system});
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    in
    {
      inherit lib;
      nixosModules = import ./modules/nixos { inherit lib self; };
      homeManagerModules = import ./modules/home-manager;

      packages = forEachSystem (pkgs: import ./pkgs { inherit inputs pkgs; });

      checks = forEachSystem (pkgs: import ./pkgs { inherit inputs pkgs; });

      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      overlays = import ./overlays { inherit inputs outputs; };

      nixosConfigurations = {
        # Main desktop
        acrux = lib.nixosSystem {
          modules = [ ./hosts/acrux ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Oracle Cloud Ampere A1 in Osaka
        antares = lib.nixosSystem {
          modules = [ ./hosts/antares ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        # Oracle Cloud Ampere A1 (a single core instance) in Osaka
        canopus = lib.nixosSystem {
          modules = [ ./hosts/canopus ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

    };
}
