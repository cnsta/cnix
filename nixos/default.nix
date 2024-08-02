let
  shared = [
    ./system

    ./locale

    ./srv/audio
    ./srv/greetd
    ./srv/gnome-keyring
    ./srv/gvfs
    ./srv/locate
    ./srv/mullvad
    ./srv/openssh
    ./srv/power
    ./srv/samba
    ./srv/udisks
    ./srv/fwupd
  ];

  adampad =
    shared
    ++ [
      ./system/var/nh/adampad.nix
    ];
  cnix =
    shared
    ++ [
      ./system/var/nh/cnix.nix
    ];
  toothpc =
    shared
    ++ [
      ./system/var/nh/toothpc-nh.nix
    ];
in {
  inherit shared adampad cnix toothpc;
}
