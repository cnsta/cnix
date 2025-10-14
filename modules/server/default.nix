{
  self,
  lib,
  ...
}: let
  clib = import "${self}/lib/server" {inherit lib;};
in {
  imports = [
    {
      _module.args.clib = clib;
    }
    ./options.nix
    ./infra
    ./services
  ];
}
