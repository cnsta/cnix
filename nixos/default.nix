let
  desktop = [
    ./core/hyprland.nix
    ./core/zsh.nix
    ./core/fonts.nix

    ./locale

    ./services/audio
    ./services/greetd
    ./services/gnome-keyring
    ./services/gvfs
    ./services/locate
    ./services/mullvad
    ./services/openssh
    ./services/power
    ./services/samba
    ./services/udisks
  ];

  laptop =
    desktop
    ++ [
      ./services/fwupd
    ];
in {
  inherit desktop laptop;
}
