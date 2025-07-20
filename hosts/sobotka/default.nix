{
  lib,
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.cnst = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "git"
      "mysql"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "kvm"
      "network"
      "gamemode"
      "adbusers"
      "rtkit"
      "users"
      "plocate"
      "fuse"
      "fail2ban"
      "vaultwarden"
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
    ./server.nix
  ];

  boot.initrd.luks.devices."luks-47b35d4b-467a-4637-a5f9-45177da62897".device = "/dev/disk/by-uuid/47b35d4b-467a-4637-a5f9-45177da62897";

  networking = {
    hostName = "sobotka";
    domain = "cnst.dev";
    nftables.tables = {
      filter = {
        family = "inet";
        content = ''
          table inet filter {
            chain input {
              type filter hook input priority 0;

              # Accept localhost traffic
              iifname lo accept

              # Accept established/related traffic
              ct state { established, related } accept

              # Allow ICMP (ping etc.)
              ip protocol icmp accept
              ip6 nexthdr icmpv6 accept

              # Allow SSH
              tcp dport 22 accept

              # --- Custom rules for Deluge ---
              ip saddr 192.168.88.0/24 tcp dport 8112 accept
              ip saddr 192.168.88.0/24 udp dport { 58846, 6881 } accept

              # Drop other external access to these ports
              tcp dport 8112 drop
              udp dport { 58846, 6881 } drop

              # Default deny
              counter drop
            }

            chain forward {
              type filter hook forward priority 0;
              accept
            }

            chain output {
              type filter hook output priority 0;
              accept
            }
          }
        '';
      };
    };
  };

  powerManagement.enable = false;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  environment.variables.NH_FLAKE = "/home/cnst/.nix-config";

  #   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "25.05";
}
