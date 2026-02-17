{
  inputs,
  homeImports,
  self,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (self) outputs;

      specialArgs = {
        inherit inputs outputs self;
        bgs = inputs.dotfiles.lib.bgs;
      };

      commonModules = [
        "${self}/nix"
        self.modules.nixos
        self.modules.settings
        inputs.agenix.nixosModules.default
        inputs.nix-index-database.nixosModules.default
      ];
    in
    {
      kima = nixosSystem {
        inherit specialArgs;
        modules = commonModules ++ [
          ./kima
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@kima";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.pulsar-x2.nixosModules.default
        ];
      };

      bunk = nixosSystem {
        inherit specialArgs;
        modules = commonModules ++ [
          ./bunk
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@bunk";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.pulsar-x2.nixosModules.default
        ];
      };

      sobotka = nixosSystem {
        inherit specialArgs;
        modules = commonModules ++ [
          ./sobotka
          self.modules.server
          inputs.authentik.nixosModules.default
          inputs.pulsar-x2.nixosModules.default
        ];
      };

      ziggy = nixosSystem {
        inherit specialArgs;
        modules = commonModules ++ [
          ./ziggy
          self.modules.server
        ];
      };

      toothpc = nixosSystem {
        inherit specialArgs;
        modules = commonModules ++ [
          ./toothpc
          {
            home-manager = {
              users.toothpick.imports = homeImports."toothpick@toothpc";
              extraSpecialArgs = specialArgs;
            };
          }
          inputs.pulsar-x2.nixosModules.default
        ];
      };
    };
}
