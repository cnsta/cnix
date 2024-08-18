{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.ssh;
in {
  options = {
    modules.sysd.ssh.enable = mkEnableOption "Enables ssh";
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
    programs.ssh = {
      startAgent = true;
    };
  };
}
