{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption mkDefault types;
  cfg = config.nixos.system.locale;
  defaultCategories = [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ];
in {
  options = {
    nixos.system.locale = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable locale configuration.";
      };
      timeZone = mkOption {
        type = types.str;
        default = null;
        description = "The system time zone (e.g., \"Europe/Stockholm\").";
      };
      defaultLocale = mkOption {
        type = types.str;
        default = null;
        description = "The default locale for the system (e.g., \"en_US.UTF-8\").";
      };
      extraLocale = mkOption {
        type = types.str;
        default = null;
        description = ''
          The locale to use for specific LC_* categories.
          If set, it will override the categories specified in `locale.categories`.
          Example: "sv_SE.UTF-8".
        '';
      };
      categories = mkOption {
        type = types.listOf types.str;
        default = defaultCategories;
        description = ''
          List of LC_* categories to override with `locale.extraLocale`.
          Defaults to common locale categories.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    time.timeZone = mkDefault cfg.timeZone;
    i18n.defaultLocale = mkDefault cfg.defaultLocale;
    i18n.extraLocaleSettings = mkIf (cfg.extraLocale != null) (
      lib.foldl' (attrs: lc: attrs // {"${lc}" = cfg.extraLocale;}) {} cfg.categories
    );
  };
}
