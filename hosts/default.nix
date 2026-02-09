# Yanked from fufexan!
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
        inherit
          inputs
          outputs
          self
          ;
        bgs = inputs.dotfiles.lib.bgs;
      };
    in
    {
      kima = nixosSystem {
        inherit specialArgs;
        modules = [
          ./kima
          "${self}/nix"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@kima";
              extraSpecialArgs = specialArgs;
            };
          }
          self.modules.nixos
          self.modules.settings
          inputs.agenix.nixosModules.default
          inputs.pulsar-x2-control.nixosModules.default
        ];
      };
      bunk = nixosSystem {
        inherit specialArgs;
        modules = [
          ./bunk
          "${self}/nix"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@bunk";
              extraSpecialArgs = specialArgs;
            };
          }
          self.modules.nixos
          self.modules.settings
          inputs.agenix.nixosModules.default
        ];
      };
      sobotka = nixosSystem {
        inherit specialArgs;
        modules = [
          ./sobotka
          "${self}/nix"
          self.modules.nixos
          self.modules.settings
          self.modules.server
          inputs.agenix.nixosModules.default
          inputs.authentik.nixosModules.default
        ];
      };
      ziggy = nixosSystem {
        inherit specialArgs;
        modules = [
          ./ziggy
          "${self}/nix"
          self.modules.nixos
          self.modules.settings
          self.modules.server
          inputs.agenix.nixosModules.default
        ];
      };
      toothpc = nixosSystem {
        inherit specialArgs;
        modules = [
          ./toothpc
          "${self}/nix"
          {
            home-manager = {
              users.toothpick.imports = homeImports."toothpick@toothpc";
              extraSpecialArgs = specialArgs;
            };
          }
          self.modules.nixos
          self.modules.settings
          inputs.agenix.nixosModules.default
        ];
      };
    };
}
