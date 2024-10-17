{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.home.userd.dconf;
in {
  options = {
    home.userd.dconf.settings.color-scheme = mkOption {
      type = types.str;
      default = "prefer-dark";
    };
  };
  config = {
    dconf = {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = cfg.settings.color-scheme;
        };
      };
    };
  };
}
