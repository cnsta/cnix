{pkgs, ...}: {
  services = {
    samba = {
      enable = true;
      package = pkgs.samba4Full;
      openFirewall = true;
    };
    avahi = {
      publish.enable = true;
      publish.userServices = true;
      enable = true;
      openFirewall = true;
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
