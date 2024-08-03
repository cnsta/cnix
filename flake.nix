{
  description = "My (i.e. fufexan's) NixOS flake configuration";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./home
        ./hosts
        # ./nixos/pkgs
      ];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
            pkgs.nodePackages.prettier
          ];
        };
        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    # Nix environs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";
    lanzaboote.url = "github:nix-community/lanzaboote";
    # Sandbox wrappers for programs
    # nixpak = {
    #   url = "github:nixpak/nixpak";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs-small";
    #     flake-parts.follows = "flake-parts";
    #   };
    # };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # cachyos
    chaotic.url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Schizophrenic Firefox configuration
    # schizofox = {
    #   url = "github:schizofox/schizofox";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs-small";
    #     flake-parts.follows = "flake-parts";
    #     nixpak.follows = "nixpak";
    #   };
    # };
    anyrun.url = "github:anyrun-org/anyrun";
    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     home-manager.follows = "hm";
    #     systems.follows = "systems";
    #     darwin.follows = "";
    #   };
    # };
  };
}
