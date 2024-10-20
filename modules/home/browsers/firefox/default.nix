{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.browsers.firefox;
in {
  imports = [
    inputs.nur.hmModules.nur
  ];
  options = {
    home.browsers.firefox.enable = mkEnableOption "Enables firefox";
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
          extensions = with config.nur.repos.rycee.firefox-addons; [
            ublock-origin
            sponsorblock
            clearurls
            swedish-dictionary
            reddit-enhancement-suite
            return-youtube-dislikes
            enhancer-for-youtube # unfree
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
    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
}
