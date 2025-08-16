{config, ...}: {
  server = {
    enable = true;
    email = "adam@cnst.dev";
    domain = "cnix.dev";
    user = "share";
    group = "share";
    uid = 974;
    gid = 973;

    unbound = {
      enable = true;
    };
    caddy = {
      enable = true;
    };
    homepage-dashboard = {
      enable = false;
    };
    bazarr = {
      enable = false;
    };
    prowlarr = {
      enable = false;
    };
    lidarr = {
      enable = false;
    };
    sonarr = {
      enable = false;
    };
    radarr = {
      enable = false;
    };
    jellyseerr = {
      enable = false;
    };
    jellyfin = {
      enable = false;
    };
    uptime-kuma = {
      enable = false;
    };
    vaultwarden = {
      enable = false;
    };
    fail2ban = {
      enable = false;
    };
    podman = {
      enable = true;
      qbittorrent = {
        enable = false;
        port = 8080;
      };
      slskd = {
        enable = false;
      };
      pihole = {
        enable = true;
        port = 8053;
      };
    };
  };
}
