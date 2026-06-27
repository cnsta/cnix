{inputs, ...}: {
  flake = {
    lib.clib = import (../lib) {inherit (inputs.nixpkgs) lib;};
    modules = {
      cnix = {
        programs.imports = [./programs];
        services.imports = [./services];
        server.imports = [./server];
        settings.imports = [./settings];
      };
    };
  };
}
