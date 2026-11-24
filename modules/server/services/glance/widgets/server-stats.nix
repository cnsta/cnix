{
  config,
  srv,
  ...
}: [
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
          ${srv.mediaDir} = {
            hide = false;
            name = "Media";
          };
        };
      }
    ];
  }
]
