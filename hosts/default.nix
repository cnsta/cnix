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

    cnstConfig = "${self}/users/cnst";
    toothpickConfig = "${self}/users/toothpick";

    umodPath = "${self}/modules/home";
    smodPath = "${self}/modules/system";

    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;

    # get these into the module system
    specialArgs = {inherit inputs self userConfig systemConfig hostConfig cnstConfig toothpickConfig umodPath smodPath;};
  in {
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
        self.nixosModules.nixos
        self.nixosModules.settings
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
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
        self.nixosModules.nixos
        self.nixosModules.settings
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
    sobotka = nixosSystem {
      inherit specialArgs;
      modules = [
        ./sobotka
        "${self}/nix"
        {
          home-manager = {
            users.cnst.imports = homeImports."cnst@sobotka";
            extraSpecialArgs = specialArgs;
          };
        }
        self.nixosModules.nixos
        self.nixosModules.settings
        self.nixosModules.server
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
        self.nixosModules.nixos
        self.nixosModules.settings
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
  };
}
