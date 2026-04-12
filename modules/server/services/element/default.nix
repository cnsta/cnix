{
  config,
  lib,
  pkgs,
  ...
}:
let
  unit = "element";
  domain = config.server.infra.www.url;
  cfg = config.server.services.${unit};

  elementConfig = {
    default_server_name = domain;
    disable_custom_urls = true;
    disable_guests = true;
    disable_login_language_selector = false;
    disable_3pid = true;
    brand = domain;

    integrations_ui_url = "https://scalar.vector.im/";
    integrations_rest_url = "https://scalar.vector.im/api";
    integrations_widgets_urls = [
      "https://scalar.vector.im/_matrix/integrations/v1"
      "https://scalar.vector.im/api"
      "https://scalar-staging.vector.im/_matrix/integrations/v1"
      "https://scalar-staging.vector.im/api"
      "https://scalar-staging.riot.im/scalar/api"
    ];
    integrations_jitsi_widget_url = "https://scalar.vector.im/api/widgets/jitsi.html";

    default_country_code = "PT";

    show_labs_settings = true;
    features = { };
    default_federate = true;
    default_theme = "dark";
    room_directory = {
      servers = [ domain ];
    };
    setting_defaults = {
      breadcrumbs = true;
    };
    jitsi = {
      preferred_domain = "meet.element.io";
    };
    element_call = {
      url = "https://call.element.io";
      participant_limit = 8;
      brand = "Element Call";
    };
    map_style_url = "https://api.maptiler.com/maps/streets/style.json?key=fU3vlMsMn4Jb6dnEIFsx";
  };
in
{
  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."element" =
      let
        elementPkg = pkgs.element-web.override {
          conf = elementConfig;
        };
      in
      {
        root = elementPkg;
        forceSSL = false;
        listen = [
          {
            addr = "127.0.0.1";
            port = cfg.port;
          }
        ];
      };
  };
}
