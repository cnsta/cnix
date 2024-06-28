{pkgs, ...}: {
  environment = {
    systemPackages = [
      # Dev
      pkgs.fd
      pkgs.python3
      pkgs.hyprlang

      # Util
      pkgs.tmux
      pkgs.tmuxifier
    ];
  };
}
