{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.lact;
in
{
  options = {
    nixos.programs.lact.enable = mkEnableOption "Enables lact for GPU monitoring and tweaking";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lact
    ];

    systemd.services.lact = {
      enable = cfg.enable;
      description = "GPU Control Daemon";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
    };
  };
}
