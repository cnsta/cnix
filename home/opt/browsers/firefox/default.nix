{
  inputs,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;
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
}
