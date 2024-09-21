# Yanked from fufexan!
{
  inputs,
  homeImports,
  self,
  pkgs,
  ...
}: {
  flake.nixosConfigurations = let
    # custom paths
    userConfig = "${self}/home";
    systemConfig = "${self}/system";
    hostConfig = "${self}/hosts";

    cnstConfig = "${self}/home/users/cnst";
    toothpickConfig = "${self}/home/users/toothpick";

    userModules = "${self}/home/modules";
    systemModules = "${self}/system/modules";

    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${systemConfig}";

    # get the basic config to build on top of
    inherit (import "${systemConfig}") shared;

    # get these into the module system
    specialArgs = {inherit inputs self userConfig systemConfig hostConfig cnstConfig toothpickConfig userModules systemModules;};
  in {
    cnix = nixosSystem {
      inherit specialArgs;
      modules =
        shared
        ++ [
          ./cnix
          "${mod}/boot/lanzaboote"
          "${mod}/nix/nh/cnst"
          "${mod}/dev"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnix";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.agenix.nixosModules.default
        ];
    };
    toothpc = nixosSystem {
      inherit specialArgs;
      modules =
        shared
        ++ [
          ./toothpc
          "${mod}/boot/lanzaboote"
          "${mod}/nix/nh/toothpick"
          "${mod}/dev"
          {
            home-manager = {
              users.toothpick.imports = homeImports."toothpick@toothpc";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.agenix.nixosModules.default
        ];
    };
    cnixpad = nixosSystem {
      inherit specialArgs;
      modules =
        shared
        ++ [
          ./cnixpad
          "${mod}/boot"
          "${mod}/nix/nh/cnst"
          "${mod}/dev"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnixpad";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.agenix.nixosModules.default
        ];
    };
  };
}
