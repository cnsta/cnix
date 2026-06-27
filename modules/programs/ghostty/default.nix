{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    genAttrs
    optionalAttrs
    getExe
    generators
    ;
  cfg = config.cnix.programs.ghostty;
  acct = config.cnix.settings.accounts;

  shellCommand =
    if config.cnix.programs.nushell.enable or false
    then "${getExe pkgs.nushell}"
    else if config.cnix.programs.fish.enable or false
    then "${getExe pkgs.fish}"
    else if config.cnix.programs.zsh.enable or false
    then "${getExe pkgs.zsh}"
    else null;

  settings =
    {
      theme = "Afterglow";
      focus-follows-mouse = true;
      resize-overlay = "never";
      background-opacity = "0.95";
      gtk-single-instance = true;
      window-decoration = false;
      window-padding-x = "4,4";
      font-family = "InputMonoNarrow Light";
      quit-after-last-window-closed = false;

      keybind = [
        "ctrl+f=start_search"
        "ctrl+page_up=scroll_page_fractional:-0.5"
        "ctrl+page_down=scroll_page_fractional:0.5"
        "ctrl+end=scroll_to_bottom"
        "ctrl+home=scroll_to_top"
      ];

      # cursor-color = "#C2C2B0";
      # cursor-style = "block";
      # cursor-style-blink = false;
      # shell-integration-features = "no-cursor";
    }
    // optionalAttrs (shellCommand != null) {
      command = shellCommand;
    };

  ghosttyConfig =
    generators.toKeyValue {
      mkKeyValue = generators.mkKeyValueDefault {} " = ";
      listsAsDuplicateKeys = true;
    }
    settings;
in {
  options.cnix.programs.ghostty = {
    enable = mkEnableOption "ghostty";
    primary = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Mark ghostty as the primary terminal for this host.
        Sets cnix.settings.accounts.terminal, which exports $TERMINAL
        and is read by launchers like fuzzel.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hjem.users = genAttrs acct.defaultUsers (_: {
        packages = [pkgs.ghostty];
        xdg.config.files."ghostty/config".source = pkgs.writeText "ghostty-config" ghosttyConfig;
      });
    }

    (mkIf cfg.primary {
      cnix.settings.accounts.terminal = pkgs.ghostty;
    })
  ]);
}
