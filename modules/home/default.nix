{
  self,
  lib,
  ...
}:
let
  clib = import (self + "/lib/home") { inherit lib; };
in
{
  imports = [
    {
      _module.args.clib = clib;
    }
    ./programs
    ./services
  ];
}
