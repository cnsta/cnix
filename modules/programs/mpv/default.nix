{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.programs.mpv;
  acct = config.cnix.settings.accounts;

  mpvWithScripts = pkgs.mpv.override {
    scripts = with pkgs.mpvScripts; [
      mpris
      uosc
      thumbfast
      sponsorblock
      autocrop
      webtorrent-mpv-hook
    ];
  };

  fsrShader = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/FSR.glsl";

  mpvConfFromAttrs = settings:
    concatStringsSep "\n" (
      mapAttrsToList (
        k: v: let
          s =
            if builtins.isBool v
            then
              (
                if v
                then "yes"
                else "no"
              )
            else toString v;
        in "${k}=${s}"
      )
      settings
    );

  inputConfFromAttrs = bindings: concatStringsSep "\n" (mapAttrsToList (k: v: "${k} ${v}") bindings);

  mpvSettings = user: {
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
    glsl-shader = "/home/${user}/.config/mpv/shaders/FSR.glsl";
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

  mpvBindings = {
    "ctrl+a" = "script-message osc-visibility cycle";
  };
in {
  options.cnix.programs.mpv.enable = mkEnableOption "mpv";

  config = mkIf cfg.enable {
    environment.systemPackages = [mpvWithScripts];

    hjem.users = genAttrs acct.defaultUsers (user: {
      packages = [
        # pkgs.jellyfin-mpv-shim
        pkgs.yt-dlp
      ];

      xdg.config.files = {
        "mpv/mpv.conf".text = mpvConfFromAttrs (mpvSettings user);
        "mpv/input.conf".text = inputConfFromAttrs mpvBindings;
        # "mpv/shaders/FSR.glsl".source = fsrShader;
        "yt-dlp/config".text = ''
          -o /home/${user}/media/videos/youtube/%(title)s.%(ext)s
        '';
      };
    });
  };
}
