{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.userd.gtk;
in {
  options = {
    home.userd.gtk.enable = mkEnableOption "Enables miscellaneous GTK elements";
  };
  config = mkIf cfg.enable {
    home = {
      packages = [pkgs.glib]; # gsettings
      pointerCursor = {
        # package = pkgs.catppuccin-cursors.latteDark;
        # name = "catppuccin-latte-dark-cursors";
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 28;
        gtk.enable = true;
        x11.enable = true;
      };
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.orchis-theme;
        name = "Orchis-Grey-Dark-Compact";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      font = {
        name = "Input Sans Narrow Light";
        size = 10;
      };
      cursorTheme = {
        # package = pkgs.catppuccin-cursors.latteDark;
        # name = "catppuccin-latte-dark-cursors";
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 28;
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

      gtk3.extraConfig = {
        # Lets be easy on the eyes. This should be easy to make dependent on
        # the "variant" of the theme, but I never use a light theme anyway.
        gtk-application-prefer-dark-theme = true;

        # Decorations
        gtk-decoration-layout = "appmenu:none";
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;

        # Silence bells and whistles, quite literally.
        gtk-error-bell = 0;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;

        # Fonts
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };

      gtk4.extraConfig = {
        # Prefer dark theme.
        gtk-application-prefer-dark-theme = true;

        # Decorations.
        gtk-decoration-layout = "appmenu:none";

        # Sounds, again.
        gtk-error-bell = 0;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;

        # Fonts, you know the drill.
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
      };
    };
  };
}
