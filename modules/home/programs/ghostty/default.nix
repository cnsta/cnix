{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge getExe;
  cfg = config.home.programs.ghostty;
  host = osConfig.networking.hostName;
in {
  options = {
    home.programs.ghostty.enable = mkEnableOption "Enables ghostty";
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.ghostty = {
        enable = true;
        enableBashIntegration = config.programs.bash.enable;
        enableFishIntegration = config.programs.fish.enable;
        enableZshIntegration = config.programs.zsh.enable;
        settings = {
          theme = "GruvboxDark";
          focus-follows-mouse = true;
          resize-overlay = "never";
          background-opacity = 0.95;
          gtk-single-instance = true;
          window-decoration = false;
          window-padding-x = "4,4";
          font-family = "InputMonoNarrow Light";

          # cursor-color = "#C2C2B0";
          # cursor-style = "block";
          # cursor-style-blink = false;
          # shell-integration-features = "no-cursor";
        };
      };
    }
    (mkIf (host == "cnixtop") {
      programs.ghostty.settings.command = "${getExe config.programs.fish.package}";
    })
    (mkIf (host == "cnixpad") {
      programs.ghostty.settings.command = "${getExe config.programs.fish.package}";
    })
    (mkIf (host == "toothpc") {
      programs.ghostty.settings.command = "${getExe config.programs.zsh.package}";
    })
  ]);
}
