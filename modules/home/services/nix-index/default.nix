# Copied from https://github.com/Misterio77/nix-config
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.home.services.nix-index;
in {
  options = {
    home.services.nix-index.enable = mkEnableOption "Enables dunst";
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
              mkdir -p ~/.cache/nix-index
              cd ~/.cache/nix-index
              name="index-${pkgs.stdenv.system}"
              wget -N "https://github.com/nix-community/nix-index-database/releases/latest/download/$name"
              ln -sf "$name" "files"
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
      Install.WantedBy = ["timers.target"];
    };
  };
}
