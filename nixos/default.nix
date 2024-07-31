let
  desktop = [
    ./core

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
