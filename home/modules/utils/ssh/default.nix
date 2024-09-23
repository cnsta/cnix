{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.ssh;
in {
  options = {
    modules.utils.ssh.enable = mkEnableOption "Enables ssh";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      userKnownHostsFile = "~/.ssh/known_hosts";
    };
  };
}
