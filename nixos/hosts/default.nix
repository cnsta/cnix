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
    inherit (import "${self}/nixos") adampad cnix toothpc;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    cnix = nixosSystem {
      inherit specialArgs;
      modules =
        cnix
        ++ [
          ./cnix
          "${mod}/system/boot/lanzaboote.nix"
          "${mod}/system/var/network/cnix.nix"

          "${mod}/srv/blueman"

          "${mod}/opt/gaming.nix"
          "${mod}/opt/android"
          "${mod}/opt/workstation"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnix";
              optSpecialArgs = specialArgs;
            };
          }

          # inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
    toothpc = nixosSystem {
      inherit specialArgs;
      modules =
        toothpc
        ++ [
          ./toothpc
          "${mod}/system/boot/lanzaboote.nix"
          "${mod}/system/var/network/toothpc.nix"

          "${mod}/opt/gaming.nix"
          {
            home-manager = {
              users.toothpick.imports = homeImports."toothpick@toothpc";
              optSpecialArgs = specialArgs;
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
          "${mod}/system/boot/boot.nix"
          "${mod}/system/var/network/adampad.nix"

          "${mod}/srv/blueman"

          "${mod}/opt/android"
          {
            home-manager = {
              users.adam.imports = homeImports."adam@adampad";
              optSpecialArgs = specialArgs;
            };
          }

          # inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
