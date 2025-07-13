{
  config,
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.home.programs.fuzzel;
  host = osConfig.networking.hostName;
in {
  options = {
    home.programs.fuzzel.enable = mkEnableOption "Enables fuzzel";
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            layer = "overlay";
            font = "Input Sans Narrow Light:size=12";
            launch-prefix = "uwsm app --";
            lines = "8";
          };
          colors = {
            background = "282828ff";
            text = "928374ff";
            prompt = "ebdbb2ff";
            placeholder = "928374ff";
            input = "ebdbb2ff";
            match = "ebdbb2ff";
            selection = "32302fff";
            selection-text = "ebdbb2ff";
            selection-match = "ebdbb2ff";
            counter = "4c7a5dff";
            border = "4c7a5dff";
          };
          border = {
            width = 3;
            radius = 0;
          };
        };
      };
    }
    (mkIf (host == "kima") {
      programs.fuzzel.settings.main.terminal = "${inputs.ghostty.packages.x86_64-linux.default}/bin/ghostty";
    })
    (mkIf (host == "bunk") {
      programs.fuzzel.settings.main.terminal = "${pkgs.foot}/bin/foot";
    })
    (mkIf (host == "toothpc") {
      programs.fuzzel.settings.main.terminal = "${pkgs.alacritty}/bin/alacritty";
    })
  ]);
}
