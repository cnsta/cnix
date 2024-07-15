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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nix-gl = {
    #  url = "github:nix-community/nixgl";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    # anyrun.url = "github:anyrun-org/anyrun";
    # Neovim Nightly
    #neovim-nightly-overlay = {
    #  url = "github:nix-community/neovim-nightly-overlay";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    # Firefox Nightly
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #fenix = {
    #  url = "github:nix-community/fenix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    # ags.url = "github:Aylur/ags";

    # HYPRLAND ECOSYSTEM
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    lanzaboote,
    flake-utils,
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
    devShells = forEachSystem (pkgs: import ./nixos/core/shells/dev.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      cnix = lib.nixosSystem {
        modules = [
          ./nixos/hosts/cnix
          lanzaboote.nixosModules.lanzaboote
        ];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      adampad = lib.nixosSystem {
        modules = [./nixos/hosts/adampad];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      toothpc = lib.nixosSystem {
        modules = [
          ./nixos/hosts/toothpc
          lanzaboote.nixosModules.lanzaboote
        ];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
