{config, ...}: [
  {
    type = "custom-api";
    title = "WAN";
    "title-url" = "https://${config.cnix.settings.site.router}";
    cache = "15m";
    url = "https://ipinfo.io/json";
    template = builtins.readFile ./templates/wan.html;
  }
]
