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
    genAttrs
    concatStringsSep
    concatMap
    ;
  cfg = config.cnix.services.dunst;
  acct = config.cnix.settings.accounts;

  iconThemePkg = pkgs.papirus-icon-theme;
  iconThemeName = "Papirus";

  iconPath = concatStringsSep ":" (
    concatMap
    (
      size:
        map (cat: "${iconThemePkg}/share/icons/${iconThemeName}/${size}/${cat}") [
          "actions"
          "applications"
          "categories"
          "devices"
          "emblems"
          "emotes"
          "mimetypes"
          "places"
          "status"
        ]
    )
    [
      "16x16"
      "32x32"
    ]
  );

  toDunstIni = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v:
        if builtins.isInt v
        then toString v
        else if builtins.isBool v
        then
          (
            if v
            then "true"
            else "false"
          )
        else "\"${toString v}\"";
    } "=";
  };

  settings = {
    global = {
      follow = "mouse";
      padding = 16;
      horizontal_padding = 16;
      font = "Input Sans Compressed Light 12";
      frame_color = "#4c7a5d";
      separator_color = "#504945";
      icon_path = iconPath;
    };

    urgency_low = {
      background = "#282828";
      foreground = "#d5c4a1";
    };
    urgency_normal = {
      background = "#282828";
      foreground = "#d5c4a1";
    };
    urgency_critical = {
      background = "#282828";
      foreground = "#c14a4a";
    };
  };
in {
  options.cnix.services.dunst.enable = mkEnableOption "dunst notification daemon";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.dunst
      iconThemePkg
    ];

    systemd.user.services.dunst = {
      description = "Dunst notification daemon";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.dunst}/bin/dunst";
        Restart = "on-failure";
      };
    };

    hjem.users = genAttrs acct.defaultUsers (_: {
      files.".config/dunst/dunstrc" = {
        generator = toDunstIni;
        value = settings;
        clobber = true;
      };
    });
  };
}
