{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.git;
in
{
  options = {
    nixos.programs.git.enable = mkEnableOption "Enables git";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
    };
  };
}
