{ inputs, self, ... }:
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
        { _module.args.clib = self.lib.clib; }
        (self + "/system")
        self.modules.cnix.programs
        self.modules.cnix.services
        self.modules.cnix.settings
        inputs.nix-index-database.nixosModules.default
      ];

      userModule =
        { config, ... }:
        let
          user = config.cnix.settings.accounts.username;
        in
        {
          cnix.settings.accounts.defaultUsers = [ user ];

          hjem.users.${user} = {
            inherit user;
            directory = ("/home/" + user);
          };
        };

      workstationModules = [
        inputs.hjem.nixosModules.default
        (self + "/scripts")
        userModule
      ];

      mkWorkstation =
        host:
        nixosSystem {
          inherit specialArgs;
          modules = commonModules ++ [ host ] ++ workstationModules;
        };

      mkServer =
        host:
        nixosSystem {
          inherit specialArgs;
          modules = commonModules ++ [
            host
            self.modules.cnix.server
          ];
        };
    in
    {
      kima = mkWorkstation ./kima;
      bunk = mkWorkstation ./bunk;
      toothpc = mkWorkstation ./toothpc;
      sobotka = mkServer ./sobotka;
      ziggy = mkServer ./ziggy;
    };
}
