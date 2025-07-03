{
  pkgs,
  lib,
  config,
  # osConfig,
  ...
}:
# let
#   isCnixpad = osConfig.networking.hostName == "cnixpad";
# in
{
  imports = [
    ./modules
  ];
  # ++ lib.optionals isCnixpad [./cpmodules.nix];

  home = {
    username = "cnstlab";
    homeDirectory = "/home/cnstlab";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
    packages = with pkgs; [
      # misc.system
      bun
    ];

    sessionVariables = {
      BROWSER = "zen";
      EDITOR = "hx";
      TERM = "xterm-256color";
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;

  # systemd.user.targets.tray.Unit.Requires = lib.mkForce ["graphical-session.target"];
}
