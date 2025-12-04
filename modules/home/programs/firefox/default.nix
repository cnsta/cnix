{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.home.programs.firefox;
in
{
  imports = [
    # inputs.nur.hmModules.nur
  ];
  options = {
    home.programs.firefox.enable = mkEnableOption "Enables firefox";
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles = {
        default = {
          search = {
            force = true;
            default = "noaiddg";
            privateDefault = "noaiddg";
            order = [
              "noaiddg"
              "google"
            ];
            engines = {
              nix-packages = {
                name = "Nix Packages";
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              nixos-wiki = {
                name = "NixOS Wiki";
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                definedAliases = [ "@nw" ];
              };

              mynixos = {
                name = "MyNixOS";
                urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
                iconMapObj."16" = "https://mynixos.com/favicon.ico";
                definedAliases = [ "@mn" ];
              };

              noaiddg = {
                name = "noai.DuckDuckGo";
                urls = [ { template = "https://noai.duckduckgo.com/?q={searchTerms}"; } ];
                iconMapObj."16" = "https://duckduckgo.com/favicon.ico";
                definedAliases = [ "@noaiddg" ];
              };
            };
          };
          bookmarks = { };
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
