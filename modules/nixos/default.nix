{
  self,
  lib,
  ...
}:
let
  clib = import (self + "/lib") { inherit lib; };
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
