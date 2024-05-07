{
  description = "NixOS configuration";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
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
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      packages = forEachSystem (pkgs: import ./pkgs { inherit inputs pkgs; });

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });

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
