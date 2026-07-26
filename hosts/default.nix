{
  inputs,
  self,
  withSystem,
  lib,
  ...
}: let
  hosts = import ./registry.nix;

  userModule = {config, ...}: let
    user = config.cnix.settings.accounts.username;
  in {
    cnix.settings.accounts.defaultUsers = [user];

    hjem.users.${user} = {
      inherit user;
      directory = "/home/" + user;
    };
  };

  mkHost = name: {
    system,
    class,
    ...
  }:
    withSystem system ({pkgs, ...}:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules =
          [
            inputs.nixpkgs.nixosModules.readOnlyPkgs
            {
              nixpkgs.pkgs = pkgs;
              networking.hostName = name;
              _module.args = {
                inherit hosts;
                clib = self.lib.clib;
                bgs = inputs.dotfiles.lib.bgs;
                inherit self;
              };
            }
            ./${name}
            (self + "/system")
            (self + "/scripts")
            self.modules.nixos.programs
            self.modules.nixos.services
            self.modules.nixos.settings
            inputs.nix-index-database.nixosModules.default
            inputs.hjem.nixosModules.default
            userModule
          ]
          ++ lib.optional (class == "server") self.modules.nixos.server;
      });
in {
  flake.nixosConfigurations = lib.mapAttrs mkHost hosts;
}
