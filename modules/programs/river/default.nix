{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.river;

  monitors = config.cnix.settings.monitors;
  transforms = ["normal" "90" "180" "270" "flipped" "flipped-90" "flipped-180" "flipped-270"];

  outputBlock = m: let
    rate =
      if lib.hasSuffix "Hz" m.refreshRate || lib.hasSuffix "hz" m.refreshRate
      then m.refreshRate
      else "${m.refreshRate}Hz";
    body =
      ["mode ${toString m.width}x${toString m.height}@${rate}"]
      ++ lib.optional (m.position != "auto") "position ${lib.replaceStrings ["x"] [","] m.position}"
      ++ ["scale ${m.scale}" "transform ${builtins.elemAt transforms m.transform}"];
  in
    if !m.enable
    then ["    output ${m.name} disable"]
    else ["    output ${m.name} {"] ++ map (l: "        " + l) body ++ ["    }"];

  profileBlock = name: mons:
    lib.concatStringsSep "\n" (["profile ${name} {"] ++ lib.concatMap outputBlock mons ++ ["}"]);

  connected = builtins.filter (m: m.enable) monitors;
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
      levee = {
        enable = true;
        idle.enable = true;
      };
      kanshi = {
        enable = true;
        config =
          lib.concatStringsSep "\n\n" (
            lib.optional (monitors != []) (profileBlock config.networking.hostName monitors)
            ++ lib.optionals (builtins.length connected > 1)
            (map (m: profileBlock "${config.networking.hostName}-${m.name}" [m]) connected)
          )
          + "\n";
      };
    };
  };
}
