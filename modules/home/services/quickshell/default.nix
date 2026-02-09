{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.quickshell;
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  dependencies = with pkgs; [
    bash
    coreutils
    gawk
    ripgrep
    procps
    util-linux
  ];

  GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (
    with pkgs;
    [
      evolution-data-server
      libical
      glib.out
      libsoup_3
      json-glib
      gobject-introspection
    ]
  );
in
{
  options = {
    home.services.quickshell.enable = mkEnableOption "Enables quickshell";
  };
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (python3.withPackages (
          ps: with ps; [
            pygobject3
            pyusb
          ]
        ))
        brightnessctl
        cava
        cliphist
        ddcutil
        wlsunset
        wl-clipboard
        imagemagick
        wget
        quickshell
        kdePackages.qtmultimedia
        kdePackages.qtquick3d
        kdePackages.qtsvg
        kdePackages.qtshadertools
        kdePackages.qtimageformats
      ];
    };

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
        After = "graphical-session.target";
      };
      Service = {
        Environment = lib.concatStringsSep " " [
          "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}"
          "GI_TYPELIB_PATH=${GI_TYPELIB_PATH}"
        ];
        ExecStart = "${lib.getExe quickshell} --path /home/cnst/.repositories/cnixshell/shell.qml";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
