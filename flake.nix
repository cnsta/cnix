{
  description = "cnix nix";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./users
        ./hosts
        ./modules
      ];

      perSystem = {pkgs, ...}: {
        devShells = import ./nix/shell {inherit pkgs inputs;};
        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    # Nix environment
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";
    lanzaboote.url = "github:nix-community/lanzaboote";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Hyprland environment
    hyprland.url = "github:hyprwm/hyprland";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    # Chaotic
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Miscellaneous
    ghostty.url = "github:ghostty-org/ghostty";

    helix-flake.url = "github:helix-editor/helix";

    nvf.url = "github:notashelf/nvf";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    anyrun.url = "github:anyrun-org/anyrun";
    microfetch.url = "github:NotAShelf/microfetch";
    agenix.url = "github:ryantm/agenix";

    # Rust toolchain
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "git+https://git.sr.ht/~canasta/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom apps
    tuirun = {
      url = "git+https://git.sr.ht/~canasta/tuirun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
