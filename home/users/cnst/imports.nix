{pkgs, ...}: {
  imports = [
    # CORE
    # .gui
    ../../core/gui
    # .tui
    ../../core/tui/git/cnst.nix
    ../../core/tui/shell/cnst.nix
    # .system
    ../../core/system/polkit.nix

    # EXTRA
    ../../extra/foot
    ../../extra/firefox
    ../../extra/neovim
  ];
  home = {
    packages = with pkgs; [
      # .applications
      alacritty
      keepassxc
      qbittorrent
      webcord
      calcurse
      virt-manager
    ];
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      TERM = "foot";
    };
  };
}
