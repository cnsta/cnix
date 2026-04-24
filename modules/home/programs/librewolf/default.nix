{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption singleton;
  cfg = config.home.programs.librewolf;

  amo = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";

  search = {
    force = true;
    default = "CniXNG";
    engines."CniXNG" = {
      urls = singleton {
        template = "https://search.cnix.dev/";
        params = singleton {
          name = "q";
          value = "{searchTerms}";
        };
      };
      definedAliases = [ "@cx" ];
    };
  };

  settings = {
    "webgl.disabled" = false;
    "privacy.trackingprotection.enabled" = true;
    "privacy.clearOnShutdown.cookies" = false;
    "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
    "privacy.clearOnShutdown_v2.cache" = false;
    "media.autoplay.blocking_policy" = 2;
    "middlemouse.paste" = false;
    "general.autoScroll" = true;
    "browser.tabs.inTitlebar" = 1;
    "browser.tabs.warnOnClose" = false;
    "browser.translations.enable" = false;
    "browser.startup.page" = 3;
    "search.suggest.enabled" = true;
    "search.suggest.searches" = true;
    "sidebar.verticalTabs" = true;
    "reader.color_scheme" = "dark";
    "font.name.serif.x-western" = "Inter";
    "layout.css.prefers-color-scheme.content-override" = 0;
  };
in
{
  options = {
    home.programs.librewolf.enable = mkEnableOption "Enables librewolf browser";
  };

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;

      profiles.default = {
        id = 0;
        isDefault = true;
        inherit settings search;
      };

      policies = {
        ExtensionSettings = {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = amo "bitwarden-password-manager";
            installation_mode = "force_installed";
          };
          "CanvasBlocker@kkapsner.de" = {
            install_url = amo "canvasblocker";
            installation_mode = "force_installed";
          };
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            install_url = amo "return-youtube-dislikes";
            installation_mode = "force_installed";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = amo "sponsorblock";
            installation_mode = "force_installed";
          };
        };
      };
    };
  };
}
