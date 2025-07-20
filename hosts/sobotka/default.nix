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
    firewall.extraCommands = ''
      # Allow LAN access to Deluge Web UI
      nft add rule inet filter input ip saddr 192.168.88.0/24 tcp dport 8112 accept

      # Allow LAN access to Deluge daemon and torrent port
      nft add rule inet filter input ip saddr 192.168.88.0/24 udp dport { 58846, 6881 } accept

      # Block all other access to those ports
      nft add rule inet filter input tcp dport 8112 drop
      nft add rule inet filter input udp dport { 58846, 6881 } drop
    '';
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
