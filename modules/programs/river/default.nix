{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types genAttrs;
  cfg = config.cnix.programs.river;
  acct = config.cnix.settings.accounts;

  mod = cfg.modifier;

  monitors = config.cnix.settings.monitors;
  transforms = ["normal" "90" "180" "270" "flipped" "flipped-90" "flipped-180" "flipped-270"];

  outputBlock = m: let
    rate =
      if lib.hasSuffix "Hz" m.refreshRate || lib.hasSuffix "hz" m.refreshRate
      then m.refreshRate
      else "${m.refreshRate}Hz";
    body =
      ["mode ${toString m.width}x${toString m.height}@${rate}"]
      ++ lib.optional (m.position != "auto") "position ${lib.replaceStrings ["x"] [","] m.position}"
      ++ ["scale ${m.scale}" "transform ${builtins.elemAt transforms m.transform}"];
  in
    if !m.enable
    then ["    output ${m.name} disable"]
    else ["    output ${m.name} {"] ++ map (l: "        " + l) body ++ ["    }"];

  profileBlock = name: mons:
    lib.concatStringsSep "\n" (["profile ${name} {"] ++ lib.concatMap outputBlock mons ++ ["}"]);

  connected = builtins.filter (m: m.enable) monitors;

  procPattern = name: "^\\.?${name}(-wrapped)?$";

  toggle = name: cmd: "pkill '${procPattern name}' || ${cmd}";
  runOnce = name: cmd: "pgrep '${procPattern name}' >/dev/null || ${cmd}";
in {
  imports = [inputs.river-rhine.nixosModules.default];

  options.cnix.programs.river = {
    enable = mkEnableOption "Enables river with the rhine window manager";

    modifier = mkOption {
      type = types.enum ["super" "alt" "ctrl"];
      default = "super";
      description = ''
        Primary modifier. Defaults to alt.
      '';
    };

    config = mkOption {
      type = types.lines;
      description = ''
        The full contents of ~/.config/river/config.rh, shared by rhine and
        channel. Rhine hot-reloads this when it changes, and falls back to its
        built-in minimal.rh if it fails to parse, so a config that appears to
        "revert" is a syntax error, not a lost file.

        Session plumbing does not belong here. channel and kanshi are user
        units owned by programs.river-rhine, XDG_CURRENT_DESKTOP is exported by
        the session script before river starts, and the environment is
        published to systemd and D-Bus from inside the compositor once it is
        actually up. Anything in startup[] is an untracked child of river.
      '';
      default = ''
        layout {
            * bsp
        }

        layout_config {
            bsp {
                # Each leaf insets by `gaps` on every side, so adjacent windows
                # end up 2*gaps apart. 2 here matches niri's `gaps 4`.
                gaps 2
                # Drop gaps entirely when a workspace holds one window.
                smart_gaps true
            }
        }

        env {
            ELECTRON_OZONE_PLATFORM_HINT wayland
            QT_QPA_PLATFORM wayland
            SDL_VIDEODRIVER wayland,x11
            GTK_CSD 0
        }

        window_management {
            focus_follows_pointer true
            pointer_follows_focus true

            float_move 0.1

            border {
                width 4
                colours {
                    focus rgb8, 0x4c, 0x7a, 0x5d
                    inactive rgb8, 0x50, 0x49, 0x45
                }
            }
        }

        animations {
            move {
                duration 125_000
                easing expOut
            }
            resize {
                duration 125_000
                easing expOut
            }
            workspace {
                duration 125_000
                easing sinInOut
            }
        }

        keybinds [
            ${mod}, t, launch, ghostty
            ${mod}, space, launch, fuzzel
            ${mod}, w, launch, zen
            ${mod}+shift, w, launch, zen --private-window
            ${mod}, e, launch, nautilus
            ${mod}+shift, l, launch, waylock
            ${mod}, i, launch, ${toggle "byt" "byt"}
            ctrl+shift, Escape, launch, ${runOnce "resources" "resources"}

            ${mod}, q, close, Focus
            ${mod}, f, fullscreen, toggle, Focus
            ${mod}, v, floating, toggle, Focus
            ${mod}, s, layoutCommand, bsp, changeSplit
            ${mod}+shift, s, layoutCommand, bsp, swapAllSplits

            ${mod}, h, moveFocus, Left
            ${mod}, j, moveFocus, Down
            ${mod}, k, moveFocus, Up
            ${mod}, l, moveFocus, Right
            ${mod}, Left, moveFocus, Left
            ${mod}, Down, moveFocus, Down
            ${mod}, Up, moveFocus, Up
            ${mod}, Right, moveFocus, Right

            ${mod}+shift, h, moveWindow, Left
            ${mod}+shift, j, moveWindow, Down
            ${mod}+shift, k, moveWindow, Up
            ${mod}+shift, l, moveWindow, Right
            ${mod}+shift, Left, moveWindow, Left
            ${mod}+shift, Down, moveWindow, Down
            ${mod}+shift, Up, moveWindow, Up
            ${mod}+shift, Right, moveWindow, Right

            ${mod}, Tab, focusWorkspace, PrevActive
            ${mod}+ctrl, Left, focusWorkspace, Previous
            ${mod}+ctrl, Right, focusWorkspace, Next

            ${mod}, 1, focusWorkspace, 0
            ${mod}, 2, focusWorkspace, 1
            ${mod}, 3, focusWorkspace, 2
            ${mod}, 4, focusWorkspace, 3
            ${mod}, 5, focusWorkspace, 4
            ${mod}, 6, focusWorkspace, 5
            ${mod}, 7, focusWorkspace, 6
            ${mod}, 8, focusWorkspace, 7
            ${mod}, 9, focusWorkspace, 8

            ${mod}+shift, 1, moveToWorkspace, 0
            ${mod}+shift, 2, moveToWorkspace, 1
            ${mod}+shift, 3, moveToWorkspace, 2
            ${mod}+shift, 4, moveToWorkspace, 3
            ${mod}+shift, 5, moveToWorkspace, 4
            ${mod}+shift, 6, moveToWorkspace, 5
            ${mod}+shift, 7, moveToWorkspace, 6
            ${mod}+shift, 8, moveToWorkspace, 7
            ${mod}+shift, 9, moveToWorkspace, 8

            none,  Insert, launch, screenshot.sh area
            shift, Insert, launch, screenshot.sh output
            alt,   Insert, launch, screenshot.sh ocr
            ctrl,  Insert, launch, screenshot.sh screen

            none, XF86AudioRaiseVolume, launch, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ --limit 1.0 5%+
            none, XF86AudioLowerVolume, launch, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            none, XF86AudioMute, launch, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            none, XF86AudioMicMute, launch, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
            none, XF86AudioPlay, launch, playerctl play-pause
            none, XF86AudioNext, launch, playerctl next
            none, XF86AudioPrev, launch, playerctl previous
            none, XF86MonBrightnessUp, launch, brightnessctl --class=backlight set +10%
            none, XF86MonBrightnessDown, launch, brightnessctl --class=backlight set 10%-

            ${mod}+shift, Delete, exit
        ]

        pointer_binds [
            ${mod}, Left, pointerOp, move
            ${mod}, Right, pointerOp, resize
        ]

        windowrules [
            appid, dev.cnst.byt, float, true
            appid, net.nokyan.Resources, float, true
            appid, com.saivert.pwvucontrol, float, true
            appid, org.gnome.FileRoller, float, true
            appid, org.gnome.Calculator, float, true
            appid, swayimg, float, true
            appid, polkit-gnome-authentication-agent-1, float, true
            appid, vesktop, workspace, 4
        ]

        startup [
        ]

        input {
            profiles {
                keyboard {
                    keyboard {
                        layout se
                        variant nodeadkeys
                        repeat {
                            rate 50
                            delay 300
                        }
                    }
                }

                mouse {
                    libinput {
                        accel_profile flat
                        accel_speed 0.0
                    }
                }

                touchpad {
                    libinput {
                        natural_scroll true
                        tap_to_click true
                        click_method clickfinger
                        disable_while_typing true
                        scroll_method two_finger
                        accel_profile adaptive
                    }
                }
            }

            rules [
                type, keyboard, keyboard
                type, pointer, mouse
                name, *ouchpad, touchpad
            ]
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.river-rhine = {
      enable = true;
      channel.enable = true;
      kanshi = {
        enable = true;
        config =
          lib.concatStringsSep "\n\n" (
            lib.optional (monitors != []) (profileBlock config.networking.hostName monitors)
            ++ lib.optionals (builtins.length connected > 1)
            (map (m: profileBlock "${config.networking.hostName}-${m.name}" [m]) connected)
          )
          + "\n";
      };
    };

    hjem.users = genAttrs acct.defaultUsers (_user: {
      files.".config/river/config.rh" = {
        text = cfg.config;
        clobber = true;
      };
    });
  };
}
