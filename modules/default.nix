{
  flake.modules = {
    home.imports = [ ./home ];
    nixos.imports = [ ./nixos ];
    server.imports = [ ./server ];
    settings.imports = [ ./settings ];
  };
}
