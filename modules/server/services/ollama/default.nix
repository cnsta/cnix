{
  config,
  lib,
  pkgs,
  ...
}:
let
  unit = "ollama";
  cfg = config.server.services.${unit};
in
{
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

    virtualisation.oci-containers.containers = {
      intel-llm = {
        autoStart = true;
        image = "intelanalytics/ipex-llm-inference-cpp-xpu:latest";
        devices = [
          "/dev/dri:/dev/dri:rwm"
        ];
        volumes = [
          "/var/lib/ollama:/models"
        ];
        environment = {
          OLLAMA_ORIGINS = "http://192.168.*";
          SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS = "1";
          ONEAPI_DEVICE_SELECTOR = "level_zero:0";
          OLLAMA_HOST = "[::]:11434";
          no_proxy = "localhost,127.0.0.1";
          DEVICE = "Arc";
          OLLAMA_NUM_GPU = "999";
          ZES_ENABLE_SYSMAN = "1";
        };
        cmd = [
          "/bin/sh"
          "-c"
          "/llm/scripts/start-ollama.sh && echo 'Startup script finished, container is now idling.' && sleep infinity"
        ];
        extraOptions = [
          "--net=host"
          "--memory=32G"
          "--shm-size=16g"
        ];
      };
    };
  };
}
