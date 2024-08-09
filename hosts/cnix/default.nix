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
    # hashedPasswordFile = config.age.secrets.openai.path;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTdWHnYsr+sWg1tMSPRUaQhB8msdCoanaJOtP8v1ZBX root@cnix"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtk/N0vZIangyccQoDq1e+k+t9gdymaYvjIs+Xh6TIMuDEO2piaiAs5PvIPQI3FPlPG4rQKgJwE3RwTCM1XXX/euhXzzmae32E/eLBF7fOtT0YjA07sXAW+vjKI7xhEdh+3D2Vi59taV/sw8QsNwTYFo1BQjjwqSHN+xhM3myFKEMquTxo6LqfFMR8oLSTyC4qUwk+H2w/6kmVFJa/7qGVhbEpryM/Oj+LMqzG6PYfmWzZ2qPFJ4FWHLTLVstBxpvT4p91lm0Z6aC+4KyYo52vwzEk2U/GGwzzc5DbXgyAzhaU8BM8IWkaRiE7RU8PNM1vRQ05L1JJ1T2o9a92QeZiJxz+3cgV/yZUYOKdZNrfskKpOzdm00yfhznVpI8y1lfgyvd+eJRLLpeOkGnAO3fW7RLLcwVKX6st8gBWf2SKWNFyuWdTU9SJC/sgttiBrsCiBTItKYLE8ihdJLrJn+cIxUoFe6WjZa9bv0WWetiW3g1WgiJeIWnlWERdDsxKfatwkE8mfPJtt6mZio/cLyC16HN57fNkqMqelca9deaXu2hwWBuE0dsOsL6HlhY8lFwQ5P+x7D3gZGpYWMZl35uqDt2AzFGje3Rrzv0NO7UUixeIit6c5BWhSxIpSgpl6065Uo5+jfeQlbaO1Kri4wwCR6VvQ/F0v+4IQZLSzOC3Gw== root@cnix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMWwiz9YWBMUKFtAmF3xTEdBW27zkBH8UYaqWWcs70d cnst@cnix"
    ];
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
    ];
  };

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    consoleLogLevel = 3;
    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
    kernelParams = [
      "amd_pstate=active"
      "quiet"
      "splash"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "23.11";
}
