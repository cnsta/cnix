{self, ...}: {
  imports = [
    "${self}/lib/server"
    ./options.nix
    ./infra
    ./services
  ];
}
