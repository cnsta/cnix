{
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    xkb = {
      extraLayouts.hhkbse = {
        description = "HHKBse by cnst";
        languages = ["se"];
        symbolsFile = /home/cnst/.nix-config/hosts/cnix/xkb/symbols/hhkbse;
      };
      layout = "hhkbse";
      # dir = "/home/cnst/.nix-config/nixos/xkb";
      variant = "";
      options = "lv3:rwin_switch";
    };
  };
}
