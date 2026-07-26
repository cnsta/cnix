{lib}: let
  inherit
    (builtins)
    attrNames
    isAttrs
    isList
    isBool
    ;

  mkValueString = v:
    if isBool v
    then lib.boolToString v
    else if v == null
    then ""
    else toString v;

  indent = "  ";

  # Inside a block: indented, no further nesting permitted.
  renderKV = key: value:
    if isList value
    then
      lib.concatMapStringsSep "\n" (
        item:
          if isAttrs item
          then throw "toHyprconf: attrset inside a block list (key='${key}') not supported"
          else "${indent}${key}=${mkValueString item}"
      )
      value
    else if isAttrs value
    then throw "toHyprconf: nested attrset (key='${key}') not supported"
    else "${indent}${key}=${mkValueString value}";

  # Hyprland requires bezier definitions before the animations that use them.
  keyPriority = k:
    if k == "bezier"
    then 0
    else if k == "animation"
    then 1
    else 2;

  ltKey = a: b: let
    pa = keyPriority a;
    pb = keyPriority b;
  in
    if pa != pb
    then pa < pb
    else a < b;

  renderBlock = name: attrs: let
    sortedKeys = builtins.sort ltKey (attrNames attrs);
    body = lib.concatMapStringsSep "\n" (k: renderKV k attrs.${k}) sortedKeys;
  in "${name} {\n${body}\n}";

  # Top level: no indent, blocks permitted.
  renderEntry = key: value:
    if isList value
    then
      lib.concatMapStringsSep "\n" (
        item:
          if isAttrs item
          then renderBlock key item
          else "${key}=${mkValueString item}"
      )
      value
    else if isAttrs value
    then renderBlock key value
    else "${key}=${mkValueString value}";

  isScalar = v: !(isList v || isAttrs v);
in {
  # Blocks first, bare assignments last.
  toHyprconf = attrs: let
    parts = lib.partition (k: isScalar attrs.${k}) (attrNames attrs);
  in
    lib.concatMapStringsSep "\n" (k: renderEntry k attrs.${k}) (parts.wrong ++ parts.right);
}
