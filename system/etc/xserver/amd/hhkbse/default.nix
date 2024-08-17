{hostConfig, ...}: let
  path = "${hostConfig}/cnix/xkb/symbols";
in {
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    xkb = {
      extraLayouts.hhkbse = {
        description = "HHKBse by cnst";
        languages = ["se"];
        symbolsFile = "${path}/hhkbse";
      };
      layout = "hhkbse";
      variant = "";
      options = "lv3:rwin_switch";
    };
  };
}
