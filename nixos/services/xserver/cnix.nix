let
  homeDir = builtins.getEnv "HOME";
in {
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    xkb = {
      extraLayouts.hhkbse = {
        description = "HHKBse by cnst";
        languages = ["se"];
        symbolsFile = "${homeDir}/.nix-config/nixos/hosts/cnix/xkb/symbols/hhkbse";
      };
      layout = "hhkbse";
      # dir = "/home/cnst/.nix-config/nixos/xkb";
      variant = "";
      options = "lv3:rwin_switch";
    };
  };
}
