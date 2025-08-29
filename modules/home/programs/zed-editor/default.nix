{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.zed-editor;
in
{
  options = {
    home.programs.zed-editor.enable = mkEnableOption "Enables zed-editor";
  };
  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
    };
  };
}
