{ lib }:
let
  serverLib = import ./server { inherit lib; };
in
{
  inherit (serverLib) server;

  mkWhen =
    host:
    let
      scopes = {
        k = host == "kima";
        b = host == "bunk";
        s = host == "sobotka";
        t = host == "toothpc";
        z = host == "ziggy";
      };
      validLetters = builtins.concatStringsSep "" (builtins.attrNames scopes);
      lookup =
        ch: scopes.${ch} or (throw "clib.mkWhen: unknown scope letter '${ch}' (valid: ${validLetters})");
    in
    letters: lib.mkIf (lib.any lookup (lib.stringToCharacters letters));

  mkEn =
    host:
    let
      scopes = {
        k = host == "kima";
        b = host == "bunk";
        s = host == "sobotka";
        t = host == "toothpc";
        z = host == "ziggy";
      };
      validLetters = builtins.concatStringsSep "" (builtins.attrNames scopes);
      lookup =
        ch: scopes.${ch} or (throw "clib.mkEn: unknown scope letter '${ch}' (valid: ${validLetters})");
      when = letters: lib.mkIf (lib.any lookup (lib.stringToCharacters letters));
    in
    letters: when letters { enable = true; };

  mkAll = _host: attrs: attrs;
  mkAllEn = _host: { enable = true; };
  mkNone = _host: lib.mkIf false { enable = true; };
}
