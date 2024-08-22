# Yanked from fufexan!
{
  inputs,
  homeImports,
  self,
  ...
}: {
  flake.nixosConfigurations = let
    # custom paths
    userConfig = "${self}/home";
    systemConfig = "${self}/system";
    hostConfig = "${self}/hosts";

    cnstConfig = "${self}/home/users/cnst";
    toothpickConfig = "${self}/home/users/toothpick";
    adamConfig = "${self}/home/users/adam";

    userModules = "${self}/home/modules";
    systemModules = "${self}/system/modules";

    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${systemConfig}";

    # get the basic config to build on top of
    inherit (import "${systemConfig}") shared;

    # get these into the module system
    specialArgs = {inherit inputs self userConfig systemConfig hostConfig cnstConfig toothpickConfig adamConfig userModules systemModules;};
  in {
    cnix = nixosSystem {
      inherit specialArgs;
      modules =
        shared
        ++ [
          ./cnix
          "${mod}/boot/lanzaboote"
          "${mod}/nix/nh/cnix"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnix";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          (import "${mod}/dev")
        ];
    };
    toothpc = nixosSystem {
      inherit specialArgs;
      modules =
        shared
        ++ [
          ./toothpc
          "${mod}/boot/lanzaboote"
          "${mod}/nix/nh/toothpc"
          {
            home-manager = {
              users.toothpick.imports = homeImports."
            toothpick@toothpc";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.chaotic.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          (import "${mod}/dev")
        ];
    };
    adampad = nixosSystem {
      inherit specialArgs;
      modules =
        shared
        ++ [
          ./adampad
          "${mod}/boot"
          "${mod}/nix/nh/adampad"
          {
            home-manager = {
              users.adam.imports = homeImports."adam@adampad";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.chaotic.nixosModules.default
          inputs.sops-nix.nixosModules.sops
        ];
    };
  };
}
