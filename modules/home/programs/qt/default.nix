# from fufexan
{
  lib,
  pkgs,
  config,
  ...
}:
let
  Orchis-kde = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Orchis-kde";
    rev = "b2a96919eee40264e79db402b915f926436100ad";
    hash = "sha256-C1eXHJdmqqOWFJUhTNhYWzjtCJrCkxS1DJlPtfD9gxE=";
    sparseCheckout = [ "Kvantum" ];
  };

  qtctConf = {
    Appearance = {
      custom_palette = false;
      icon_theme = config.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
      style = "kvantum";
    };
  };

  defaultFont = "${config.gtk.font.name},${builtins.toString config.gtk.font.size}";

  themeScript =
    theme:
    pkgs.writeShellScript "theme-start-${theme}" ''
      ${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme "'prefer-${theme}'"
      cat <<EOF > ${config.xdg.configHome}/Kvantum/kvantum.kvconfig
      [General]
      theme=Orchis${lib.optionalString (theme == "dark") "Dark"}
      EOF
    '';
in
{
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    # Kvantum config
    "Kvantum" = {
      source = "${Orchis-kde}/Kvantum";
      recursive = true;
    };

    # qtct config
    "qt5ct/qt5ct.conf".text =
      let
        default = ''"${defaultFont},-1,5,50,0,0,0,0,0"'';
      in
      lib.generators.toINI { } (
        qtctConf
        // {
          Fonts = {
            fixed = default;
            general = default;
          };
        }
      );

    "qt6ct/qt6ct.conf".text =
      let
        default = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      in
      lib.generators.toINI { } (
        qtctConf
        // {
          Fonts = {
            fixed = default;
            general = default;
          };
        }
      );
  };
  systemd.user.services = {
    theme-dark = {
      Unit.Description = "qt dark theme";
      Service = {
        Type = "oneshot";
        ExecStart = themeScript "dark";
        TimeoutStopSec = 5;
      };
    };
  };
}
