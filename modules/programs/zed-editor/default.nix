{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.zed-editor;
in
{
  options.cnix.programs.zed-editor.enable = mkEnableOption "Enables zed-editor";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.zed-editor ];
  };
}
