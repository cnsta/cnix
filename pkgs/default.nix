# yanked from @fufexan
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        # instant repl with automatic flake loading
        repl = pkgs.callPackage ./repl { };
      };
    };
}
