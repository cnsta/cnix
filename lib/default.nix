{
  lib,
  hosts,
}: let
  matchScopes = fnName: host: let
    scopes =
      if builtins.hasAttr host hosts
      then lib.mapAttrs' (name: h: lib.nameValuePair h.letter (host == name)) hosts
      else
        throw ''
          clib.${fnName}: unknown host '${host}' (known: ${lib.concatStringsSep ", " (lib.attrNames hosts)}).
          Either add it to hosts/registry.nix or fix networking.hostName.
        '';

    validLetters = lib.concatStrings (lib.attrNames scopes);

    lookup = ch:
      scopes.${ch}
      or (throw "clib.${fnName}: unknown scope letter '${ch}' (valid: ${validLetters})");
  in
    letters: lib.any lookup (lib.stringToCharacters letters);
in {
  inherit (import ./server {inherit lib;}) server;
  inherit (import ./hyprlua.nix {inherit lib;}) toHyprlua;
  inherit (import ./hyprconf.nix {inherit lib;}) toHyprconf;

  mkEn = host: let
    match = matchScopes "mkEn" host;
  in
    letters: lib.mkIf (match letters) {enable = true;};

  mkWhen = host: let
    match = matchScopes "mkWhen" host;
  in
    letters: lib.mkIf (match letters);

  mkPer = host: let
    match = matchScopes "mkPer" host;
  in
    cases:
      lib.mkMerge (
        lib.mapAttrsToList (letters: attrs: lib.mkIf (match letters) attrs) cases
      );
}
