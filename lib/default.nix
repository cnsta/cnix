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

  toHyprconf =
    let
      inherit (builtins)
        attrNames
        isAttrs
        isList
        isBool
        ;

      mkValueString =
        v:
        if isBool v then
          (if v then "true" else "false")
        else if v == null then
          ""
        else
          toString v;

      indent = "  ";

      renderBlock =
        name: attrs:
        let
          body = lib.concatMapStringsSep "\n" (k: "${indent}${k}=${mkValueString attrs.${k}}") (
            attrNames attrs
          );
        in
        "${name} {\n${body}\n}";

      renderEntry =
        key: value:
        if isList value then
          lib.concatMapStringsSep "\n" (
            item: if isAttrs item then renderBlock key item else "${key}=${mkValueString item}"
          ) value
        else if isAttrs value then
          renderBlock key value
        else
          "${key}=${mkValueString value}";

      isScalar = v: !(isList v || isAttrs v);
    in
    attrs:
    let
      keys = attrNames attrs;
      nonScalar = builtins.filter (k: !isScalar attrs.${k}) keys;
      scalar = builtins.filter (k: isScalar attrs.${k}) keys;
    in
    lib.concatMapStringsSep "\n" (k: renderEntry k attrs.${k}) (nonScalar ++ scalar);
}
