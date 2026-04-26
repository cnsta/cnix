{ lib }:
let
  home = rec {
    mkWhen =
      host:
      let
        scopes = {
          k = host == "kima";
          b = host == "bunk";
          t = host == "toothpc";
        };
        validLetters = builtins.concatStringsSep "" (builtins.attrNames scopes);
        lookup =
          ch:
          scopes.${ch} or (throw "clib.home.mkWhen: unknown scope letter '${ch}' (valid: ${validLetters})");
      in
      letters: lib.mkIf (lib.any lookup (lib.stringToCharacters letters));

    mkEn =
      host:
      let
        when = mkWhen host;
      in
      letters: when letters { enable = true; };
  };
in
{
  inherit home;
}
