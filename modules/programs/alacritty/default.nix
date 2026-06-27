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
    ;
  cfg = config.cnix.programs.alacritty;
  acct = config.cnix.settings.accounts;
  nushellEnabled = config.cnix.programs.nushell.enable or false;

  tomlFormat = pkgs.formats.toml {};

  settings =
    {
      general.import = [./afterglow.toml];

      font = {
        size = 12;
        normal = {
          family = "Input Mono Compressed";
          style = "Light";
        };
        bold = {
          family = "Input Mono Compressed";
          style = "Regular";
        };
        italic = {
          family = "Input Mono Compressed";
          style = "Italic";
        };
      };

      keyboard.bindings = [
        {
          action = "Copy";
          key = "C";
          mods = "Command";
        }
        {
          action = "Paste";
          key = "V";
          mods = "Command";
        }
        {
          action = "SearchForward";
          key = "F";
          mods = "Control";
        }
        {
          action = "ScrollHalfPageUp";
          key = "PageUp";
          mods = "Control";
        }
        {
          action = "ScrollHalfPageDown";
          key = "PageDown";
          mods = "Control";
        }
        {
          action = "ScrollToBottom";
          key = "End";
          mods = "Control";
        }
        {
          action = "ScrollToTop";
          key = "Home";
          mods = "Control";
        }
      ];

      window = {
        dynamic_title = true;
        opacity = 0.95;
        padding = {
          x = 5;
          y = 5;
        };
        dimensions = {
          columns = 120;
          lines = 35;
        };
      };
    }
    // optionalAttrs nushellEnabled {
      terminal.shell.program = "${pkgs.nushell}/bin/nu";
    };
in {
  options.cnix.programs.alacritty = {
    enable = mkEnableOption "alacritty";
    primary = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Mark alacritty as the primary terminal for this host.
        Sets cnix.settings.accounts.terminal, which exports $TERMINAL
        and is read by launchers like fuzzel.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hjem.users = genAttrs acct.defaultUsers (_: {
        packages = [pkgs.alacritty];
        xdg.config.files."alacritty/alacritty.toml".source = tomlFormat.generate "alacritty.toml" settings;
      });
    }

    (mkIf cfg.primary {
      cnix.settings.accounts.terminal = pkgs.alacritty;
    })
  ]);
}
