{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };
  home.shellAliases = {
    zr = "zellij run --";
    zrf = "zellij run --floating --";
    ze = "zellij edit";
    zef = "zellij edit --floating";
  };

  xdg.configFile."zellij/config.kdl".text = ''
    default_layout "compact"
    mouse_mode true
    copy_on_select true
    copy_command "wl-copy"
    simplified_ui  false
    scrollback_editor "/home/cnst/.nix-profile/bin/nvim"
    pane_frames true
    on_force_close "detach"

    ui {
      pane_frames {
        rounded_corners false
      }
    }

    keybinds {
            normal {
                    bind "Alt m" {
                            LaunchPlugin "file:~/.config/zellij/plugins/monocle.wasm" {
                                    in_place true
                                    kiosk true
                            };
                            SwitchToMode "Normal"
                    }
                    bind "Ctrl f" {
                            LaunchOrFocusPlugin "file:~/.config/zellij/plugins/monocle.wasm" {
                                    floating true
                            }
                            SwitchToMode "Normal"
                    }
                  bind "Alt 1" { GoToTab 1;}
                  bind "Alt 2" { GoToTab 2;}
                  bind "Alt 3" { GoToTab 3;}
                  bind "Alt 4" { GoToTab 4;}
            }

            shared_except "locked" {
                    bind "Ctrl y" {
                            LaunchOrFocusPlugin "file:~/.config/zellij/plugins/room.wasm" {
                                    floating true
                                    ignore_case true
                            }
                    }
            }
          unbind "Ctrl b" "Ctrl h" "Ctrl g" "Alt j"
        }

        themes {
          gruvbox-dark {
           bg "#282828"
           fg "#D5C4A1"
           black "#3C3836"
           red "#CC241D"
           green "#98971A"
           yellow "#D79921"
           blue "#458588"
           magenta "#B16286"
           cyan "#689D6A"
           white "#FBF1C7"
           orange "#D65D0E"
         }
       }
  '';
  xdg.configFile."zellij/layouts/gruvbox.kdl".text = ''
    layout {
        pane split_direction="vertical" {
            pane
        }

        pane size=1 borderless=true {
            plugin location="file:/home/cnst/.nix-profile/bin/zjstatus.wasm" {
                format_left  "#[fg=#FBF1C7,bold] {session} {mode} {tabs}"
                format_right "#[bg=#8A8A8A,fg=#3C3836] #[bg=#8A8A8A,fg=#3C3836,bold]{swap_layout} #[bg=#3C3836,fg=#8A8A8A]"

                mode_locked "#[fg=#B16286,bold] {name} "
                mode_normal "#[fg=#98971A,bold] {name} "
                mode_resize "#[fg=#D75F00,bold] {name} "
                mode_default_to_mode "resize"

                tab_normal "#[bg=#8A8A8A,fg=#3C3836] #[bg=#8A8A8A,fg=#3C3836,bold]{name} {sync_indicator}{fullscreen_indicator}{floating_indicator} #[bg=#3C3836,fg=#8A8A8A]"
                tab_active "#[bg=#98971A,fg=#3C3836] #[bg=#98971A,fg=#3C3836,bold]{name} {sync_indicator}{fullscreen_indicator}{floating_indicator} #[bg=#3C3836,fg=#98971A]"

                tab_sync_indicator       " "
                tab_fullscreen_indicator "□ "
                tab_floating_indicator   "󰉈 "
            }
        }
    }
  '';
}
