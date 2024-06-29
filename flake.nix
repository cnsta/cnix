{
  description = "My NixOS";

  inputs = {
    # Nix environs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";
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
    # Home manager
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    solaar,
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
