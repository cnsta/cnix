{
  pkgs,
  inputs,
  ...
}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      # gpu = {
      #   apply_gpu_optimisations = "accept-responsibility";
      #   gpu_device = 1;
      #   amd_performance_level = "high";
      # };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  services.pipewire.lowLatency.enable = true;
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
}
