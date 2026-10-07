{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.river;

  transforms = ["normal" "90" "180" "270" "flipped" "flipped-90" "flipped-180" "flipped-270"];

  toOutput = m: {
    inherit (m) name;
    value = {
      inherit (m) enable width height customMode adaptiveSync scale hdr bitDepth;
      refresh = m.refreshRate;
      transform = builtins.elemAt transforms m.transform;
      position =
        if m.position == "auto"
        then null
        else let
          xy = lib.splitString "x" m.position;
        in {
          x = lib.toInt (builtins.elemAt xy 0);
          y = lib.toInt (builtins.elemAt xy 1);
        };
    };
  };
in {
  imports = [inputs.river-delta.nixosModules.default];

  options.cnix.programs.river = {
    enable = mkEnableOption "Enables river with the delta window manager";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XKB_DEFAULT_LAYOUT = "se";
      XKB_DEFAULT_VARIANT = "nodeadkeys";
    };

    programs.river-delta = {
      enable = true;
      renderer = "vulkan";
      outputs = lib.listToAttrs (map toOutput config.cnix.settings.monitors);
      levee = {
        enable = true;
        idle.enable = true;
      };
    };
  };
}
