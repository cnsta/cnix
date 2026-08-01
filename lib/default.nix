{
  lib,
  hosts,
}: let
  letterOf = lib.mapAttrs (_: h: h.letter) hosts;

  duplicateLetters = let
    counts = lib.foldl' (acc: l: acc // {${l} = (acc.${l} or 0) + 1;}) {} (lib.attrValues letterOf);
  in
    lib.filter (l: counts.${l} > 1) (lib.attrNames counts);

  matchScopes = fnName: host: let
    scopes =
      if duplicateLetters != []
      then
        throw ''
          clib.${fnName}: duplicate host letters in hosts/registry.nix: ${lib.concatStringsSep ", " duplicateLetters}.
          Every host needs a unique letter or scopes are ambiguous.
        ''
      else if lib.hasAttr host letterOf
      then lib.mapAttrs' (name: letter: lib.nameValuePair letter (host == name)) letterOf
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

  mkScoped = fnName: host: let
    match = matchScopes fnName host;

    fromCases = cases:
      lib.mkMerge (
        lib.mapAttrsToList (letters: value: lib.mkIf (match letters) value) cases
      );
  in
    arg:
      if lib.isAttrs arg
      then fromCases arg
      else if lib.isString arg
      then (value: lib.mkIf (match arg) value)
      else
        throw ''
          clib.${fnName}: expected a scope string ("sz") or an attrset of
          scope -> config ({ "s" = ...; "z" = ...; }), got ${builtins.typeOf arg}.
        '';
in rec {
  inherit (import ./server {inherit lib;}) server;
  inherit (import ./hyprlua.nix {inherit lib;}) toHyprlua;
  inherit (import ./hyprconf.nix {inherit lib;}) toHyprconf;

  mkWhen = mkScoped "mkWhen";

  mkEn = host: letters: mkWhen host letters {enable = true;};

  mkPer = mkScoped "mkPer";

  all = {enable = true;};
  none = lib.mkIf false {};
}
