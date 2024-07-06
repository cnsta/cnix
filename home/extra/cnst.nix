{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kitty
    ./foot
    ./firefox
    ./neovim
    ./mako
  ];
  home.packages = with pkgs; [
    # APPLICATIONS
    alacritty
    keepassxc
    qbittorrent
    webcord
    calcurse
    virt-manager
  ];
}
