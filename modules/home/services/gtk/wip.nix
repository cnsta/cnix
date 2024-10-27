{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkIf;
  cfg = config.home.userd.gtk;
in {
  options = {
    home.userd.gtk.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable GTK configuration.";
    };

    home.userd.gtk.theme = mkOption {
      type = types.str;
      default = "Orchis-Grey-Dark-Compact";
      description = "GTK theme name.";
    };

    home.userd.gtk.themePackage = mkOption {
      type = types.package;
      default = pkgs.orchis-theme;
      description = "GTK theme package.";
    };

    home.userd.gtk.iconTheme = mkOption {
      type = types.str;
      default = "Adwaita";
      description = "GTK icon theme name.";
    };

    home.userd.gtk.iconThemePackage = mkOption {
      type = types.package;
      default = pkgs.adwaita-icon-theme;
      description = "GTK icon theme package.";
    };

    home.userd.gtk.font = mkOption {
      type = types.attrsOf types.anything;
      default = {
        name = "Input Sans Narrow Light";
        size = 10;
      };
      description = "GTK font configuration.";
    };

    home.userd.gtk.cursorTheme = mkOption {
      type = types.attrsOf types.anything;
      default = {
        name = "Adwaita";
        size = 28;
        package = pkgs.adwaita-icon-theme;
      };
      description = "Cursor theme configuration.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [pkgs.glib];

      pointerCursor = {
        package = cfg.cursorTheme.package;
        name = cfg.cursorTheme.name;
        size = cfg.cursorTheme.size;
        gtk.enable = true;
        x11.enable = true;
      };
    };

    gtk = {
      enable = true;

      theme = {
        package = cfg.themePackage;
        name = cfg.theme;
      };

      iconTheme = {
        package = cfg.iconThemePackage;
        name = cfg.iconTheme;
      };

      font = {
        name = cfg.font.name;
        size = cfg.font.size;
      };

      cursorTheme = {
        package = cfg.cursorTheme.package;
        name = cfg.cursorTheme.name;
        size = cfg.cursorTheme.size;
      };

      gtk2 = {
        extraConfig = ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;

        gtk-decoration-layout = "appmenu:none";
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;

        gtk-error-bell = 0;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;

        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;

        gtk-decoration-layout = "appmenu:none";

        gtk-error-bell = 0;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;

        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };
    };
  };
}
