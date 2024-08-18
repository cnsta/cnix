{
  config,
  lib,
  hostConfig,
  ...
}: let
  path = "${hostConfig}/cnix/xkb/symbols";
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.xserver.amd.hhkbse;
in {
  options = {
    modules.sysd.xserver.amd.hhkbse.enable = mkEnableOption "Enables xserver for amdgpu with HHKBSE";
  };
  config = mkIf cfg.enable {
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
  };
}
