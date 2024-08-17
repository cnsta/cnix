{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.browsers.firefox;
in {
  options = {
    modules.browsers.firefox.enable = mkEnableOption "Enables firefox";
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles = {
        default = {
          search = {
            force = true;
            default = "DuckDuckGo";
            privateDefault = "DuckDuckGo";
            order = ["DuckDuckGo" "Google"];
          };
          bookmarks = {};
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
            ublock-origin
            sponsorblock
            clearurls
            return-youtube-dislikes
            # enhancer-for-youtube # unfree
          ];
          settings = {
            "apz.overscroll.enabled" = true;
            "browser.aboutConfig.showWarning" = false;
            "general.autoScroll" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };
      };
    };
  };
}