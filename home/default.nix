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
      ./opt/browsers/firefox
      ./opt/sops
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
      ./opt/browsers/firefox
      ./opt/sops
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
      ./opt/browsers/firefox
      ./opt/sops
      ./etc
      ./bin
      ./opt
      ./srv
      ./profiles/toothpick
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  # Function to create home configuration
  makeHomeConfiguration = modules:
    homeManagerConfiguration {
      inherit pkgs extraSpecialArgs modules;
    };
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = builtins.listToAttrs (map
      (name: {
        name = builtins.replaceStrings ["@"] ["_"] name;
        value = makeHomeConfiguration homeImports.${name};
      })
      (builtins.attrNames homeImports));
  };
}
