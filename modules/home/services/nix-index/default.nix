# Copied from https://github.com/Misterio77/nix-config
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.home.services.nix-index;
in
{
  options = {
    home.services.nix-index.enable = mkEnableOption "Enables nix-index";
  };
  config = mkIf cfg.enable {
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    systemd.user.services.nix-index-database-sync = {
      Unit.Description = "fetch nix-index-database";
      Service = {
        Type = "oneshot";
        ExecStart = getExe (
          pkgs.writeShellApplication {
            name = "fetch-nix-index-database";
            runtimeInputs = with pkgs; [
              wget
              coreutils
            ];
            text = ''
              filename="index-${pkgs.stdenv.system}"
              mkdir -p ~/.cache/nix-index && cd ~/.cache/nix-index
              wget -N "https://github.com/nix-community/nix-index-database/releases/download/2025-07-06-034719/$filename"
              ln -sf "$filename" "files"
            '';
          }
        );
        Restart = "on-failure";
        RestartSec = "5m";
      };
    };
    systemd.user.timers.nix-index-database-sync = {
      Unit.Description = "Automatic github:nix-community/nix-index-database fetching";
      Timer = {
        OnBootSec = "10m";
        OnUnitActiveSec = "24h";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
