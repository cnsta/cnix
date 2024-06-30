{
  description = "My NixOS";

  inputs = {
    # Nix environs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Firefox Nightly
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Zellij Plugins
    zjstatus.url = "github:dj95/zjstatus";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    lanzaboote,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      cnix = lib.nixosSystem {
        modules = [
          ./hosts/cnix
          lanzaboote.nixosModules.lanzaboote
        ];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      adampad = lib.nixosSystem {
        modules = [./hosts/adampad];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
