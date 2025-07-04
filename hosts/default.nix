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
    cnixtop = nixosSystem {
      inherit specialArgs;

      modules = [
        ./cnixtop
        "${self}/nix"
        {
          home-manager = {
            users.cnst.imports = homeImports."cnst@cnixtop";
            extraSpecialArgs = specialArgs;
          };
        }
        self.nixosModules.nixos
        self.nixosModules.options
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
    cnixpad = nixosSystem {
      inherit specialArgs;
      modules = [
        ./cnixpad
        "${self}/nix"
        {
          home-manager = {
            users.cnst.imports = homeImports."cnst@cnixpad";
            extraSpecialArgs = specialArgs;
          };
        }
        self.nixosModules.nixos
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
    cnixlab = nixosSystem {
      inherit specialArgs;
      modules = [
        ./cnixlab
        "${self}/nix"
        {
          home-manager = {
            users.cnstlab.imports = homeImports."cnstlab@cnixlab";
            extraSpecialArgs = specialArgs;
          };
        }
        self.nixosModules.nixos
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
        inputs.chaotic.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
  };
}
