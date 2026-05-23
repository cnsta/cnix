# Nix -> Hyprland Lua (>= 0.55) generator.

{ lib }:
let
  inherit (builtins)
    isAttrs
    isList
    isBool
    isInt
    isFloat
    isString
    attrNames
    ;
  inherit (lib)
    concatStringsSep
    concatMapStringsSep
    filter
    genList
    concatStrings
    ;

  escapeStr =
    s:
    let
      r = builtins.replaceStrings [ "\\" "\"" "\n" "\t" ] [ "\\\\" "\\\"" "\\n" "\\t" ] s;
    in
    "\"${r}\"";

  isIdent = k: builtins.match "[A-Za-z_][A-Za-z0-9_]*" k != null;
  luaKey = k: if isIdent k then k else "[${escapeStr k}]";

  pad = n: concatStrings (genList (_: "  ") n);
  allScalar = l: builtins.all (e: !(isList e || isAttrs e)) l;

  toLua =
    indent: v:
    if isBool v then
      (if v then "true" else "false")
    else if isInt v then
      toString v
    else if isFloat v then
      toString v
    else if isString v then
      escapeStr v
    else if v == null then
      "nil"
    else if isList v then
      (
        if v == [ ] then
          "{}"
        else if allScalar v then
          "{ ${concatMapStringsSep ", " (toLua indent) v} }"
        else
          "{\n${
            concatMapStringsSep ",\n" (e: "${pad (indent + 1)}${toLua (indent + 1) e}") v
          }\n${pad indent}}"
      )
    else if isAttrs v then
      (
        if v ? __raw then
          v.__raw
        else if v == { } then
          "{}"
        else
          "{\n${
            concatStringsSep ",\n" (
              map (k: "${pad (indent + 1)}${luaKey k} = ${toLua (indent + 1) v.${k}}") (attrNames v)
            )
          }\n${pad indent}}"
      )
    else
      throw "toHyprlua: cannot serialize value of unsupported type";

  dirMap = {
    l = "left";
    r = "right";
    u = "up";
    d = "down";
  };

  # workspace argument may be a number, "e+1", "special:magic", etc.
  wsArg =
    a:
    if isInt a then
      toString a
    else if builtins.match "[0-9]+" a != null then
      a
    else
      escapeStr a;

  mkAction =
    b:
    if b ? raw then
      b.raw
    else
      let
        d = b.dispatcher;
        a = b.arg or null;
      in
      if d == "exec" then
        "hl.dsp.exec_cmd(${escapeStr a})"
      else if d == "killactive" then
        "hl.dsp.window.close()"
      else if d == "togglefloating" then
        "hl.dsp.window.float({ action = \"toggle\" })"
      else if d == "pseudo" then
        "hl.dsp.window.pseudo()"
      else if d == "fullscreen" then
        "hl.dsp.window.fullscreen()"
      else if d == "workspace" then
        "hl.dsp.focus({ workspace = ${wsArg a} })"
      else if d == "movetoworkspace" then
        "hl.dsp.window.move({ workspace = ${wsArg a} })"
      else if d == "movefocus" then
        "hl.dsp.focus({ direction = ${escapeStr dirMap.${a}} })"
      else if d == "movewindow" then
        "hl.dsp.window.drag()"
      else if d == "resizewindow" then
        "hl.dsp.window.resize()"
      else
        throw "toHyprlua: unmapped dispatcher '${d}'. Add it to the dispatcher table in hyprlua.nix, or use `{ key = ...; raw = \"hl.dsp....\"; }`.";

  renderConfig = c: if c == { } then "" else "hl.config(${toLua 0 c})";

  renderEnv =
    e:
    if e == { } then
      ""
    else
      concatMapStringsSep "\n" (k: "hl.env(${escapeStr k}, ${escapeStr (toString e.${k})})") (
        attrNames e
      );

  renderMonitors = ms: concatMapStringsSep "\n" (m: "hl.monitor(${toLua 0 m})") ms;

  renderCurves =
    cs:
    concatMapStringsSep "\n" (
      c: "hl.curve(${escapeStr c.name}, { type = \"bezier\", points = ${toLua 0 c.points} })"
    ) cs;

  renderAnimations = as: concatMapStringsSep "\n" (a: "hl.animation(${toLua 0 a})") as;

  renderGestures = gs: concatMapStringsSep "\n" (g: "hl.gesture(${toLua 0 g})") gs;

  renderWorkspaceRules = rs: concatMapStringsSep "\n" (r: "hl.workspace_rule(${toLua 0 r})") rs;
  renderWindowRules = rs: concatMapStringsSep "\n" (r: "hl.window_rule(${toLua 0 r})") rs;
  renderLayerRules = rs: concatMapStringsSep "\n" (r: "hl.layer_rule(${toLua 0 r})") rs;

  renderBinds =
    bs:
    concatMapStringsSep "\n" (
      b:
      let
        flags = b.flags or { };
        flagStr = if flags == { } then "" else ", ${toLua 0 flags}";
      in
      "hl.bind(${escapeStr b.key}, ${mkAction b}${flagStr})"
    ) bs;

  renderStartup =
    cmds:
    if cmds == [ ] then
      ""
    else
      "hl.on(\"hyprland.start\", function()\n"
      + concatMapStringsSep "\n" (c: "  hl.exec_cmd(${escapeStr c})") cmds
      + "\nend)";

  toHyprlua =
    cfg:
    let
      sections = [
        (renderEnv (cfg.env or { }))
        (renderMonitors (cfg.monitors or [ ]))
        (renderConfig (cfg.config or { }))
        (renderCurves (cfg.curves or [ ]))
        (renderAnimations (cfg.animations or [ ]))
        (renderGestures (cfg.gestures or [ ]))
        (renderWorkspaceRules (cfg.workspaceRules or [ ]))
        (renderWindowRules (cfg.windowRules or [ ]))
        (renderLayerRules (cfg.layerRules or [ ]))
        (renderBinds (cfg.binds or [ ]))
        (renderStartup (cfg.startup or [ ]))
      ];
    in
    concatStringsSep "\n\n" (filter (s: s != "") sections) + "\n";
in
{
  inherit toHyprlua;
}
