{
  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    TERM = "foot";
  };
  imports = [
    ./git
    ./gui
    ./shell/cnst.nix
    ./appearance
    ./system/polkit.nix
    ./system/udiskie.nix
  ];
}
