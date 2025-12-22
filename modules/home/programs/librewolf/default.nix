{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.librewolf;
in
{
  options = {
    home.programs.librewolf.enable = mkEnableOption "Enables librewolf browser";
  };
  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "media.autoplay.blocking_policy" = 2;
        "middlemouse.paste" = false;
        "general.autoScroll" = true;
        "browser.tabs.inTitlebar" = 1;
        "browser.tabs.warnOnClose" = true;
        "browser.translations.enable" = false;
        "search.suggest.enabled" = true;
        "search.suggest.searches" = true;
      };
    };
  };
}
