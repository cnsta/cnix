{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.utils.zathura;
in {
  options = {
    home.utils.zathura.enable = mkEnableOption "Enables zathura";
  };
  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        notification-error-bg = "rgba(40,40,40,1)";
        notification-error-fg = "rgba(251,73,52,1)";
        notification-warning-bg = "rgba(40,40,40,1)";
        notification-warning-fg = "rgba(250,189,47,1)";
        notification-bg = "rgba(40,40,40,1)";
        notification-fg = "rgba(184,187,38,1)";

        completion-bg = "rgba(80,73,69,1)";
        completion-fg = "rgba(235,219,178,1)";
        completion-group-bg = "rgba(60,56,54,1)";
        completion-group-fg = "rgba(146,131,116,1)";
        completion-highlight-bg = "rgba(131,165,152,1)";
        completion-highlight-fg = "rgba(80,73,69,1)";

        index-bg = "rgba(80,73,69,1)";
        index-fg = "rgba(235,219,178,1)";
        index-active-bg = "rgba(131,165,152,1)";
        index-active-fg = "rgba(80,73,69,1)";

        inputbar-bg = "rgba(40,40,40,1)";
        inputbar-fg = "rgba(235,219,178,1)";

        statusbar-bg = "rgba(80,73,69,1)";
        statusbar-fg = "rgba(235,219,178,1)";

        highlight-color = "rgba(250,189,47,0.5)";
        highlight-active-color = "rgba(254,128,25,0.5)";

        default-bg = "rgba(40,40,40,1)";
        default-fg = "rgba(235,219,178,1)";
        render-loading = true;
        render-loading-bg = "rgba(40,40,40,1)";
        render-loading-fg = "rgba(235,219,178,1)";

        recolor-lightcolor = "rgba(40,40,40,1)";
        recolor-darkcolor = "rgba(235,219,178,1)";
        recolor = true;
        recolor-keephue = true;
      };
    };
  };
}
