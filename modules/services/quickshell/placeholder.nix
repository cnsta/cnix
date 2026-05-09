{
  pkgs,
  inputs,
  ...
}:

let
  cnixshell = inputs.cnixshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [
    inputs.cnixshell.homeModules.default
  ];
  programs.cnixshell = {
    enable = true;
    package = cnixshell.override {
      calendarSupport = true;
    };
    systemd.enable = true;
  };
}
