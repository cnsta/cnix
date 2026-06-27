{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cnix.programs.bash;
in {
  options.cnix.programs.bash.enable = mkEnableOption "Enables bash";

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
    };
  };
}
