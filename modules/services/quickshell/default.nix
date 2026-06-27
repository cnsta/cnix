{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    makeSearchPath
    ;
  cfg = config.cnix.services.quickshell;
  acct = config.cnix.settings.accounts;

  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  dependencies = with pkgs; [
    bash
    coreutils
    gawk
    ripgrep
    procps
    util-linux
  ];

  GI_TYPELIB_PATH = makeSearchPath "lib/girepository-1.0" (
    with pkgs; [
      evolution-data-server
      libical
      glib.out
      libsoup_3
      json-glib
      gobject-introspection
    ]
  );
in {
  options.cnix.services.quickshell.enable = mkEnableOption "quickshell";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (quickshell.override {stdenv = pkgs.clangStdenv;})
      (python3.withPackages (
        ps:
          with ps; [
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
      kdePackages.qtmultimedia
      kdePackages.qtquick3d
      kdePackages.qtsvg
      kdePackages.qtshadertools
      kdePackages.qtimageformats
    ];

    systemd.user.services.quickshell = {
      description = "Quickshell";
      partOf = [
        "tray.target"
        "graphical-session.target"
      ];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      path = dependencies;
      environment = {
        inherit GI_TYPELIB_PATH;
      };

      serviceConfig = {
        ExecStart = "${getExe quickshell} --path /home/${acct.username}/.repositories/cnixshell/shell.qml";
        Restart = "on-failure";
      };
    };
  };
}
