{
  lib,
  config,
  pkgs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
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
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
  ];

  networking.hostName = "kima";

  environment.variables = {
    NH_FLAKE = "/home/cnst/.nix-config";
    GEMINI_API_KEY = config.age.secrets.gcapi.path;
  };

  #   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = lib.mkDefault "23.11";
}
