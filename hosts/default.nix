# Yanked from fufexan!
{
  inputs,
  homeImports,
  self,
  ...
}: {
  flake.nixosConfigurations = let
    clib = import ../lib inputs.nixpkgs.lib;
    userConfig = "${self}/home";
    systemConfig = "${self}/system";
    hostConfig = "${self}/hosts";

    cnstConfig = "${self}/users/cnst";
    toothpickConfig = "${self}/users/toothpick";

    umodPath = "${self}/modules/home";
    smodPath = "${self}/modules/system";

    inherit (inputs.nixpkgs.lib) nixosSystem;
    inherit (self) outputs;

    specialArgs = {
      inherit
        inputs
        outputs
        self
        userConfig
        systemConfig
        hostConfig
        cnstConfig
        toothpickConfig
        umodPath
        smodPath
        ;
    };
    specialArgsWithClib =
      specialArgs
      // {
        inherit clib;
      };
  in {
    kima = nixosSystem {
      specialArgs = specialArgsWithClib;
      modules = [
        ./kima
        "${self}/nix"
        {
          home-manager = {
            users.cnst.imports = homeImports."cnst@kima";
            extraSpecialArgs = specialArgsWithClib;
          };
        }
        self.modules.nixos
        self.modules.settings
        inputs.disko.nixosModules.disko
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
    bunk = nixosSystem {
      specialArgs = specialArgsWithClib;
      modules = [
        ./bunk
        "${self}/nix"
        {
          home-manager = {
            users.cnst.imports = homeImports."cnst@bunk";
            extraSpecialArgs = specialArgsWithClib;
          };
        }
        self.modules.nixos
        self.modules.settings
        inputs.chaotic.nixosModules.default
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
      specialArgs = specialArgsWithClib;
      modules = [
        ./toothpc
        "${self}/nix"
        {
          home-manager = {
            users.toothpick.imports = homeImports."toothpick@toothpc";
            extraSpecialArgs = specialArgsWithClib;
          };
        }
        self.modules.nixos
        self.modules.settings
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
  };
}
