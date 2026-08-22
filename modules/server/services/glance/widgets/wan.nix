{...}: [
  {
    type = "custom-api";
    title = "WAN";
    "title-url" = "https://192.168.88.1";
    cache = "15m";
    url = "https://ipinfo.io/json";
    template = builtins.readFile ./templates/wan.html;
  }
]
