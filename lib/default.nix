{ lib }:
let
  serverLib = import ./server { inherit lib; };

  scopesFor = host: {
    k = host == "kima";
    b = host == "bunk";
    s = host == "sobotka";
    t = host == "toothpc";
    z = host == "ziggy";
  };

  matchScopes =
    fnName: host:
    let
      scopes = scopesFor host;
      validLetters = builtins.concatStringsSep "" (builtins.attrNames scopes);
      lookup =
        ch: scopes.${ch} or (throw "clib.${fnName}: unknown scope letter '${ch}' (valid: ${validLetters})");
    in
    letters: lib.any lookup (lib.stringToCharacters letters);
in
{
  inherit (serverLib) server;

  mkWhen =
    host:
    let
      match = matchScopes "mkWhen" host;
    in
    letters: lib.mkIf (match letters);

  mkEn =
    host:
    let
      match = matchScopes "mkEn" host;
    in
    letters: lib.mkIf (match letters) { enable = true; };

  mkAll = _host: attrs: attrs;
  mkAllEn = _host: { enable = true; };
  mkNone = _host: lib.mkIf false { enable = true; };

  # hyprland-specific
  inherit (import ./hyprlua.nix { inherit lib; }) toHyprlua;

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

      renderKV =
        key: value:
        if isList value then
          lib.concatMapStringsSep "\n" (
            item:
            if isAttrs item then
              throw "toHyprconf: attrset inside a block list (key='${key}') not supported"
            else
              "${indent}${key}=${mkValueString item}"
          ) value
        else if isAttrs value then
          throw "toHyprconf: nested attrset (key='${key}') not supported"
        else
          "${indent}${key}=${mkValueString value}";

      keyPriority =
        k:
        if k == "bezier" then
          0
        else if k == "animation" then
          1
        else
          2;
      ltKey =
        a: b:
        let
          pa = keyPriority a;
          pb = keyPriority b;
        in
        if pa != pb then pa < pb else a < b;

      renderBlock =
        name: attrs:
        let
          sortedKeys = builtins.sort ltKey (attrNames attrs);
          body = lib.concatMapStringsSep "\n" (k: renderKV k attrs.${k}) sortedKeys;
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
