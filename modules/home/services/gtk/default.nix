{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.gtk;
in
{
  options = {
    home.services.gtk.enable = mkEnableOption "Enables miscellaneous GTK elements";
  };
  config = mkIf cfg.enable {
    home = {
      pointerCursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        gtk.enable = true;
        x11.enable = false;

      };
    };
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      font = {
        name = "Inter Light";
        size = 11;
      };
      cursorTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
      };

      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      };

      gtk3 = {
        extraConfig = {
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
        extraCss = ''
          window { border-radius: 0; }
        '';
      };

      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
          gtk-decoration-layout = "appmenu:none";
          gtk-error-bell = 0;
          gtk-enable-event-sounds = 0;
          gtk-enable-input-feedback-sounds = 0;
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
        };
        extraCss = ''
          window { border-radius: 0; }
        '';
      };
    };
  };
}
