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

    cnstConfig = "${self}/home/profiles/cnst";
    toothpickConfig = "${self}/home/profiles/toothpick";
    adamConfig = "${self}/home/profiles/adam";

    userModules = "${self}/home/modules";
    systemModules = "${self}/system/modules";

    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${systemConfig}";

    # get the basic config to build on top of
    inherit (import "${systemConfig}") adampad cnix toothpc;

    # get these into the module system
    specialArgs = {inherit inputs self userConfig systemConfig hostConfig cnstConfig toothpickConfig adamConfig userModules systemModules;};
  in {
    cnix = nixosSystem {
      inherit specialArgs;
      modules =
        cnix
        ++ [
          ./cnix
          "${mod}/boot/lanzaboote"
          "${mod}/etc/bluetooth"
          "${mod}/etc/graphics/amd"
          "${mod}/etc/logitech"
          "${mod}/etc/network/cnix"
          "${mod}/etc/xserver/amd/hhkbse"
          "${mod}/nix/nh/cnix"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnix";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.sops-nix.nixosModules.sops
        ];
    };
    toothpc = nixosSystem {
      inherit specialArgs;
      modules =
        toothpc
        ++ [
          ./toothpc
          "${mod}/boot/lanzaboote"
          "${mod}/etc/graphics/nvidia"
          "${mod}/etc/logitech"
          "${mod}/etc/network/toothpc"
          "${mod}/etc/xserver/nvidia"
          "${mod}/nix/nh/toothpc"
          {
            home-manager = {
              users.toothpick.imports = homeImports."toothpick@toothpc";
              extraSpecialArgs = specialArgs;
            };
          }

          # inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
    adampad = nixosSystem {
      inherit specialArgs;
      modules =
        adampad
        ++ [
          ./adampad
          "${mod}/boot"
          "${mod}/etc/bluetooth"
          "${mod}/etc/graphics/amd"
          "${mod}/etc/network/adampad"
          "${mod}/etc/xserver/amd"
          "${mod}/nix/nh/adampad"
          {
            home-manager = {
              users.adam.imports = homeImports."adam@adampad";
              extraSpecialArgs = specialArgs;
            };
          }

          # inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
