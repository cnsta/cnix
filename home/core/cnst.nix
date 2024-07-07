{
  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    TERM = "foot";
  };
  imports = [
    ./system/polkit.nix
    ./gui
    ./tui
  ];
}
