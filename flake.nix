{
  description = "cnix nix";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./hosts
        ./modules
        ./pkgs
        ./hydra.nix
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            input-fonts.acceptLicense = true;
            permittedInsecurePackages = ["olm-3.2.16"];
          };
          overlays = [
          ];
        };

        treefmt.imports = [./treefmt.nix];
        devShells.default = pkgs.mkShell {
          name = "dots";
          packages = [pkgs.git config.packages.repl];
          env.DIRENV_LOG_FORMAT = "";
        };
      };
    };

  inputs = {
    # Nix environment
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Miscellaneous
    helix-flake.url = "github:helix-editor/helix";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ashell = {
      url = "github:MalpenZibo/ashell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tailray = {
      url = "github:NotAShelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    maccel.url = "github:Gnarus-G/maccel";

    # Custom
    cnixpost = {
      url = "git+https://git.cnst.dev/cnst/cnixpost.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    river-delta = {
      url = "git+https://git.cnst.dev/cnst/delta.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "git+https://git.cnst.dev/cnst/dotfiles.git";
    };

    litecrazy = {
      url = "github:cnsta/litecrazy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    byt = {
      url = "git+https://git.cnst.dev/cnst/byt.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fonts = {
      url = "git+https://git.cnst.dev/cnst/fonts.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
