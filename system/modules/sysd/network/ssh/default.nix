{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.network.ssh;
in {
  options = {
    modules.sysd.network.ssh.enable = mkEnableOption "Enables ssh";
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
