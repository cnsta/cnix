{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf genAttrs;
  cfg = config.cnix.services.gtk;
  acct = config.cnix.settings.accounts;

  iconTheme = "Adwaita";
  iconPkg = pkgs.adwaita-icon-theme;
  cursorTheme = "Adwaita";
  cursorPkg = pkgs.adwaita-icon-theme;
  cursorSize = 32;
  fontName = "Inter Light";
  fontSize = 11;
  fontPkg = pkgs.inter;

  baseSettings = {
    gtk-icon-theme-name = iconTheme;
    gtk-cursor-theme-name = cursorTheme;
    gtk-cursor-theme-size = cursorSize;
    gtk-font-name = "${fontName} ${toString fontSize}";
    gtk-decoration-layout = "appmenu:none";
    gtk-error-bell = 0;
    gtk-enable-event-sounds = 0;
    gtk-enable-input-feedback-sounds = 0;
    gtk-xft-antialias = 1;
    gtk-xft-hinting = 1;
    gtk-xft-hintstyle = "hintslight";
  };

  gtk3Settings =
    baseSettings
    // {
      gtk-application-prefer-dark-theme = true;
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-xft-rgba = "rgb";
    };

  gtk4Settings = baseSettings;

  gtkCss = ''
    window { border-radius: 0; }
  '';

  gtk2Rc = ''
    gtk-icon-theme-name="${iconTheme}"
    gtk-cursor-theme-name="${cursorTheme}"
    gtk-cursor-theme-size=${toString cursorSize}
    gtk-font-name="${fontName} ${toString fontSize}"
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle="hintslight"
    gtk-xft-rgba="rgb"
  '';

  toGtkIni = lib.generators.toINI {};
in {
  options.cnix.services.gtk.enable = mkEnableOption "GTK theming, cursors, and dark color-scheme";

  config = mkIf cfg.enable {
    programs.dconf.enable = lib.mkDefault true;

    environment = {
      systemPackages = [pkgs.gsettings-desktop-schemas];
      sessionVariables = {
        XCURSOR_THEME = cursorTheme;
        XCURSOR_SIZE = toString cursorSize;
        GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc";
      };
    };

    systemd.user.services."gtk-color-scheme" = {
      description = "Apply GNOME color-scheme preference (prefer-dark)";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.dconf}/bin/dconf write " + "/org/gnome/desktop/interface/color-scheme \"'prefer-dark'\"";
      };
    };

    hjem.users = genAttrs acct.defaultUsers (_user: {
      packages = [
        iconPkg
        cursorPkg
        fontPkg
      ];

      files = {
        ".icons/default/index.theme" = {
          text = ''
            [Icon Theme]
            Name=Default
            Comment=Default cursor theme
            Inherits=${cursorTheme}
          '';
          clobber = true;
        };

        ".config/gtk-2.0/gtkrc" = {
          text = gtk2Rc;
          clobber = true;
        };

        ".config/gtk-3.0/settings.ini" = {
          generator = toGtkIni;
          value = {
            Settings = gtk3Settings;
          };
          clobber = true;
        };

        ".config/gtk-3.0/gtk.css" = {
          text = gtkCss;
          clobber = true;
        };

        ".config/gtk-4.0/settings.ini" = {
          generator = toGtkIni;
          value = {
            Settings = gtk4Settings;
          };
          clobber = true;
        };

        ".config/gtk-4.0/gtk.css" = {
          text = gtkCss;
          clobber = true;
        };
      };
    });
  };
}
