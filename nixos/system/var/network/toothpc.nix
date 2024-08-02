{
  networking = {
    networkmanager.enable = true;
    hostName = "toothpc";
    nftables.enable = true;
    firewall = {
      enable = true;
      interfaces = {
        "enp4s0" = {
          allowedTCPPorts = [22 80 443];
        };
      };
    };
  };
}
