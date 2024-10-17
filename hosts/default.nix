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
    mod = "${systemConfig}";

    # get the basic config to build on top of
    inherit (import "${systemConfig}") shared;

    # get these into the module system
    specialArgs = {inherit inputs self userConfig systemConfig hostConfig cnstConfig toothpickConfig umodPath smodPath;};
  in {
    cnix = nixosSystem {
      inherit specialArgs;

      modules =
        shared
        ++ [
          ./cnix
          "${mod}/dev"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnix";
              extraSpecialArgs = specialArgs;
            };
          }
          self.nixosModules.system
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
          "${mod}/dev"
          {
            home-manager = {
              users.toothpick.imports = homeImports."toothpick@toothpc";
              extraSpecialArgs = specialArgs;
            };
          }
          self.nixosModules.system
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
          "${mod}/dev"
          {
            home-manager = {
              users.cnst.imports = homeImports."cnst@cnixpad";
              extraSpecialArgs = specialArgs;
            };
          }
          self.nixosModules.system
          inputs.chaotic.nixosModules.default
          inputs.agenix.nixosModules.default
        ];
    };
  };
}
