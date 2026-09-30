{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption types;
  cfg = config.cnix.programs.river;
  # set = config.cnix.settings;

  monitors = config.cnix.settings.monitors;
  transforms = ["normal" "90" "180" "270" "flipped" "flipped-90" "flipped-180" "flipped-270"];

  outputBlock = m: let
    body =
      ["mode ${lib.optionalString m.customMode "--custom "}${toString m.width}x${toString m.height}@${m.refreshRate}Hz"]
      ++ lib.optional (m.position != "auto") "position ${lib.replaceStrings ["x"] [","] m.position}"
      ++ lib.optional (m.adaptiveSync != false) "adaptive_sync on"
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
    monitor = {
      mkOption = {
        type = types.list;
        example = 1920;
      };
    };
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
      hdr.outputs = ["DP-1"];
      renderBitDepth = 10;
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
