{
  networking = {
    networkmanager.enable = true;
    hostName = "cnix";
    nftables.enable = true;
    firewall = {
      enable = true;
      interfaces = {
        "enp7s0" = {
          allowedTCPPorts = [22 80 443];
        };
      };
    };
  };
}
