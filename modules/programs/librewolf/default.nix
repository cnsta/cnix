{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.programs.librewolf;
  acct = config.cnix.settings.accounts;

  amo = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";

  forceInstall = url: {
    install_url = url;
    installation_mode = "force_installed";
  };

  policies = {
    ExtensionSettings = {
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = forceInstall (amo "bitwarden-password-manager");
      "CanvasBlocker@kkapsner.de" = forceInstall (amo "canvasblocker");
      "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = forceInstall (amo "return-youtube-dislikes");
      "sponsorBlocker@ajay.app" = forceInstall (amo "sponsorblock");
      "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = forceInstall (amo "view-page-archive");
    };
    SearchEngines = {
      Default = "CniXNG";
      Add = [
        {
          Name = "CniXNG";
          URLTemplate = "https://search.cnix.dev/?q={searchTerms}";
          Alias = "@cx";
        }
      ];
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

  userJsText = concatStringsSep "\n" (
    mapAttrsToList (k: v: ''user_pref("${k}", ${builtins.toJSON v});'') settings
  );

  profilesIni = ''
    [Profile0]
    Name=default
    IsRelative=1
    Path=default
    Default=1

    [General]
    StartWithLastProfile=1
    Version=2
  '';
in {
  options.cnix.programs.librewolf.enable = mkEnableOption "LibreWolf";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.librewolf];

    environment.etc."librewolf/policies/policies.json".text = builtins.toJSON {inherit policies;};

    hjem.users = genAttrs acct.defaultUsers (_: {
      files = {
        ".librewolf/profiles.ini" = {
          text = profilesIni;
          clobber = true;
        };
        ".librewolf/default/user.js" = {
          text = userJsText;
          clobber = true;
        };
      };
    });
  };
}
