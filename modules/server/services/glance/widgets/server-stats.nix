{config, ...}: [
  {
    type = "server-stats";
    servers = [
      {
        type = "local";
        name = config.networking.hostName;
        "hide-mountpoints-by-default" = true;
        mountpoints = {
          "/" = {
            hide = false;
            name = "Root";
          };
          "/mnt/data" = {
            hide = false;
            name = "Media";
          };
        };
      }
    ];
  }
]
