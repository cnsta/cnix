{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/nixos";

    # get the basic config to build on top of
    inherit (import "${self}/nixos") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    cnix = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./cnix
          "${mod}/core/lanzaboote.nix"
          "${mod}/core/network/cnix.nix"

          "${mod}/hardware/cnix.nix"

          "${mod}/services/blueman"
          "${mod}/services/xserver/cnix.nix"

          "${mod}/extra/gaming.nix"
          "${mod}/extra/android"
          "${mod}/extra/workstation"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnix";
              extraSpecialArgs = specialArgs;
            };
          }

          # inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };

    # rog = nixosSystem {
    #   inherit specialArgs;
    #   modules =
    #     laptop
    #     ++ [
    #       ./rog
    #       "${mod}/core/lanzaboote.nix"

    #       "${mod}/programs/gamemode.nix"
    #       "${mod}/programs/hyprland.nix"
    #       "${mod}/programs/games.nix"

    #       "${mod}/services/kanata"
    #       {home-manager.users.mihai.imports = homeImports."mihai@rog";}
    #     ];
    # };

    # kiiro = nixosSystem {
    #   inherit specialArgs;
    #   modules =
    #     desktop
    #     ++ [
    #       ./kiiro
    #       {home-manager.users.mihai.imports = homeImports.server;}
    #     ];
    # };
  };
}
