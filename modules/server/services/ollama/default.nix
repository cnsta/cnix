{
  config,
  lib,
  pkgs,
  ...
}: let
  unit = "ollama";
  cfg = config.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ollama
      intel-compute-runtime
      intel-graphics-compiler
      level-zero
    ];
    services.open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 8001;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        BYPASS_MODEL_ACCESS_CONTROL = "True";
        OLLAMA_BASE_URL = "http://localhost:11434";
      };
    };
  };
}
