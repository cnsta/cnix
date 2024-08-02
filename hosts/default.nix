{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/sys";

    # get the basic config to build on top of
    inherit (import "${self}/sys") adampad cnix toothpc;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    cnix = nixosSystem {
      inherit specialArgs;
      modules =
        cnix
        ++ [
          ./cnix
          "${mod}/opt/boot/lanzaboote.nix"
          "${mod}/opt/hardware/cnix.nix"
          "${mod}/opt/network/cnix.nix"
          "${mod}/opt/nh/cnix.nix"
          "${mod}/opt/xserver/cnix.nix"
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
    toothpc = nixosSystem {
      inherit specialArgs;
      modules =
        toothpc
        ++ [
          ./toothpc
          "${mod}/opt/boot/lanzaboote.nix"
          "${mod}/opt/hardware/toothpc.nix"
          "${mod}/opt/network/toothpc.nix"
          "${mod}/opt/nh/toothpc.nix"
          "${mod}/opt/xserver/toothpc.nix"
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
          "${mod}/opt/boot/boot.nix"
          "${mod}/opt/hardware/adampad.nix"
          "${mod}/opt/network/adampad.nix"
          "${mod}/opt/nh/adampad.nix"
          "${mod}/opt/xserver/adampad.nix"
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
