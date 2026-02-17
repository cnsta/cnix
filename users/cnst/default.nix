{ pkgs, ... }:
{
  imports = [
    ./modules
    ./variables
  ];

  home = {
    username = "cnst";
    homeDirectory = "/home/cnst";
    stateVersion = "26.05";
    extraOutputsToInstall = [
      "doc"
      "devdoc"
    ];
    packages = with pkgs; [
      bun
    ];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  programs.home-manager.enable = true;
}
