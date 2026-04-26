{ osConfig, pkgs, ... }:
let
  user = osConfig.settings.accounts.username;

  hostSpecificVariables = {
    VISUAL = "hx";
    DEFAULT_BROWSER = (pkgs.librewolf + "/bin/librewolf");
  }
  // (
    if osConfig.networking.hostName == "bunk" then
      { }
    else
      {
        GDK_BACKEND = "wayland,x11";
        CLUTTER_BACKEND = "wayland";
      }
  );
in
{
  home = {
    username = user;
    homeDirectory = ("/home/" + user);
    stateVersion = "26.05";
    sessionVariables = hostSpecificVariables;
    extraOutputsToInstall = [
      "doc"
      "devdoc"
    ];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  programs.home-manager.enable = true;
}
