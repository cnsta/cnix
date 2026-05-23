{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    range
    concatMap
    ;
  cfg = config.cnix.programs.hyprland;
  host = config.networking.hostName;

  hostVars = {
    kima = {
      mod = "SUPER";
      terminal = "alacritty";
      browser = "librewolf";
      browserinc = "librewolf --private-window";
    };
    bunk = {
      mod = "SUPER";
      terminal = "alacritty";
      browser = "librewolf";
      browserinc = "librewolf --private-window";
    };
    toothpc = {
      mod = "ALT_L";
      terminal = "alacritty";
      browser = "librewolf";
      browserinc = "librewolf --private-window";
    };
  };
  v = hostVars.${host} or hostVars.kima;
  inherit (v)
    mod
    terminal
    browser
    browserinc
    ;

  launcher = "fuzzel";
  fileManager = "nautilus";
  yazi = "foot -e yazi";

  toggle =
    program:
    let
      prog = builtins.substring 0 14 program;
    in
    "pkill ${prog} || uwsm-app -- ${program}";
  runOnce = program: "pgrep ${program} || uwsm-app -- ${program}";

  exec = key: arg: {
    inherit key arg;
    dispatcher = "exec";
  };

  staticBinds = [
    (exec "${mod} + SPACE" (toggle launcher))
    (exec "${mod} + R" (toggle launcher))
    (exec "${mod} + Escape" (toggle "nwg-bar"))
    (exec "${mod} + L" "loginctl lock-session")
    (exec "${mod} + T" "uwsm-app -- ${terminal}")
    (exec "${mod} + W" "uwsm-app -- ${browser}")
    (exec "${mod} + SHIFT + W" "uwsm-app -- ${browserinc}")
    (exec "${mod} + I" "uwsm-app -- byt")
    {
      key = "${mod} + Q";
      dispatcher = "killactive";
    }
    (exec "${mod} + E" "uwsm-app -- ${fileManager}")
    (exec "${mod} + SHIFT + E" "uwsm-app -- ${yazi}")
    {
      key = "${mod} + F";
      dispatcher = "fullscreen";
    }
    {
      key = "${mod} + SHIFT + F";
      dispatcher = "togglefloating";
    }
    {
      key = "${mod} + P";
      dispatcher = "pseudo";
    }
    (exec "CTRL + SHIFT + Escape" (runOnce "resources"))

    (exec "${mod} + XF86MonBrightnessUp" "hyprctl dispatch dpms on")
    (exec "${mod} + XF86MonBrightnessDown" "hyprctl dispatch dpms off")

    (exec "XF86AudioLowerVolume" (runOnce "volume-control.sh --dec"))
    (exec "XF86AudioRaiseVolume" (runOnce "volume-control.sh --inc"))
    (exec "XF86AudioMute" (runOnce "volume-control.sh --toggle"))
    (exec "XF86AudioMicMute" (runOnce "volume-control.sh --toggle-mic"))
    (exec "XF86MonBrightnessDown" (runOnce "brightnessctl s 5%-"))
    (exec "XF86MonBrightnessUp" (runOnce "brightnessctl s +5%"))

    (exec "Insert" "${runOnce "grimblast"} --notify --freeze copysave area")
    (exec "SHIFT + Insert" "${runOnce "grimblast"} --notify --freeze copysave output")
    (exec "ALT + Insert" "${runOnce "grimblast"} --freeze save area - | ${runOnce "tesseract"} - - | wl-copy && ${runOnce "notify-send"} -t 3000 'OCR result copied to buffer'")
  ];

  wsBinds = concatMap (
    n:
    let
      key = if n == 10 then "0" else toString n;
    in
    [
      {
        key = "${mod} + ${key}";
        dispatcher = "workspace";
        arg = n;
      }
      {
        key = "${mod} + SHIFT + ${key}";
        dispatcher = "movetoworkspace";
        arg = n;
      }
    ]
  ) (range 1 10);

  dirs = [
    {
      arrow = "left";
      letter = "l";
      x = "-20";
      y = "0";
      relative = "true";
    }
    {
      arrow = "right";
      letter = "r";
      x = "20";
      y = "0";
      relative = "true";
    }
    {
      arrow = "up";
      letter = "u";
      x = "0";
      y = "-20";
      relative = "true";
    }
    {
      arrow = "down";
      letter = "d";
      x = "0";
      y = "20";
      relative = "true";
    }
  ];
  dirBinds = concatMap (d: [
    {
      key = "${mod} + ${d.arrow}";
      dispatcher = "movefocus";
      arg = d.letter;
    }
    {
      key = "${mod} + SHIFT + ${d.arrow}";
      raw = "hl.dsp.window.resize({ x = \"${d.x}\", y = \"${d.y}\", relative = \"${d.relative}\" })";
    }
    {
      key = "${mod} + CTRL + ${d.arrow}";
      raw = "hl.dsp.window.swap({ direction = \"${d.letter}\" })";
    }
  ]) dirs;

  mouseBinds = [
    {
      key = "${mod} + mouse:272";
      dispatcher = "movewindow";
      flags = {
        mouse = true;
      };
    }
    {
      key = "${mod} + mouse:273";
      dispatcher = "resizewindow";
      flags = {
        mouse = true;
      };
    }
  ];
in
{
  options.cnix.programs.hyprland.keybinds.enable =
    mkEnableOption "Enables keybind settings in Hyprland";
  config = mkIf cfg.keybinds.enable {
    cnix.programs.hyprland.lua.binds = staticBinds ++ wsBinds ++ dirBinds ++ mouseBinds;
  };
}
