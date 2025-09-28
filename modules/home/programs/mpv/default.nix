{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.mpv;
  inherit (config.xdg.userDirs) videos;
  inherit (config.home) homeDirectory;
  shaders_dir = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders";
in
{
  options = {
    home.programs.mpv.enable = mkEnableOption "Enables mpv";
  };
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        gpu-context = "wayland";
        vo = "gpu-next";
        video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample";
        fullscreen = false;
        keep-open = true;
        sub-auto = "fuzzy";
        sub-font = "Noto Sans Medium";
        sub-blur = 10;

        screenshot-format = "png";

        title = "\${filename} - mpv";
        script-opts = "osc-title=\${filename},osc-boxalpha=150,osc-visibility=never,osc-boxvideo=yes";
        ytdl-format = "bestvideo[height<=?1440]+bestaudio/best";
        ao = "pipewire";
        alang = "eng,en";
        slang = "eng,en,enUS";

        glsl-shader = "${homeDirectory}/.config/mpv/shaders/FSR.glsl";
        scale = "lanczos";
        cscale = "lanczos";
        dscale = "mitchell";
        deband = "yes";
        scale-antiring = 1;

        osc = "no";
        osd-on-seek = "no";
        osd-bar = "no";
        osd-bar-w = 30;
        osd-bar-h = "0.2";
        osd-duration = 750;

        really-quiet = "yes";
        autofit = "65%";
      };

      bindings = {
        "ctrl+a" = "script-message osc-visibility cycle";
      };
      scripts = with pkgs.mpvScripts; [
        mpris
        uosc
        thumbfast
        sponsorblock
        autocrop
      ];
    };
    programs.yt-dlp = {
      enable = true;
      extraConfig = ''
        -o ${videos}/youtube/%(title)s.%(ext)s
      '';
    };

    home = {
      file = {
        ".config/mpv/shaders/FSR.glsl".source = "${shaders_dir}/FSR.glsl";
      };
      packages = with pkgs; [
        jellyfin-mpv-shim
      ];
    };
  };
}
