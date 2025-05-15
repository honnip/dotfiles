{
  description = "NixOS configuration";

  inputs = {
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    hardware.url = "github:NixOS/nixos-hardware/master";
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

      homeConfigurations = {
        "honnip@acrux" = lib.homeManagerConfiguration {
          modules = [ ./home/honnip/acrux.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "honnip@antares" = lib.homeManagerConfiguration {
          modules = [ ./home/honnip/antares.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
        "honnip@canopus" = lib.homeManagerConfiguration {
          modules = [ ./home/honnip/canopus.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
