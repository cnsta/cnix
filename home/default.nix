# Yanked from fufexan
{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "cnst@cnix" = [
      ./usr/share/git/cnst
      ./usr/share/shell/cnst
      ./bin/hyprland/cnst
      ./etc
      ./bin
      ./opt
      ./srv
      ./profiles/cnst
    ];
    "adam@adampad" = [
      ./usr/share/git/cnst
      ./usr/share/shell/adam
      ./etc/hyprland/cnst
      ./etc
      ./bin
      ./opt
      ./srv
      ./profiles/adam
    ];
    "toothpick@toothpc" = [
      ./usr/share/git/toothpick
      ./usr/share/shell/toothpick
      ./bin/hyprland/toothpick
      ./etc
      ./bin
      ./opt
      ./srv
      ./profiles/toothpick
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "cnst_cnix" = homeManagerConfiguration {
        modules = homeImports."cnst@cnix";
        inherit pkgs extraSpecialArgs;
      };

      "adam_adampad" = homeManagerConfiguration {
        modules = homeImports."adam@adampad";
        inherit pkgs extraSpecialArgs;
      };

      "toothpick_toothpc" = homeManagerConfiguration {
        modules = homeImports."toothpick@toothpc";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
