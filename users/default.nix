{
  self,
  inputs,
  lib,
  ...
}:
let
  extraSpecialArgs = { inherit inputs self; };

  sharedEnv = {
    home.sessionVariables = {
      NIX_AUTO_RUN = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland,x11,windows";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      ELECTRON_FORCE_DARK_MODE = "1";
      ELECTRON_ENABLE_DARK_MODE = "1";
      ELECTRON_USE_SYSTEM_THEME = "1";
      ELECTRON_DISABLE_DEFAULT_MENU_BAR = "1";
      SSH_ASKPASS = lib.mkForce "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";
    };
  };

  sharedImports = [
    "${self}/scripts"
    self.modules.home
    sharedEnv
  ];

  homeImports = {
    "cnst@kima" = sharedImports ++ [
      ./cnst
    ];
    "cnst@bunk" = sharedImports ++ [
      ./cnst
    ];
    "toothpick@toothpc" = sharedImports ++ [
      ./toothpick
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  makeHomeConfiguration =
    modules:
    homeManagerConfiguration {
      inherit pkgs extraSpecialArgs modules;
    };
in
{
  _module.args = { inherit homeImports; };

  flake = {
    homeConfigurations = builtins.listToAttrs (
      map (name: {
        name = builtins.replaceStrings [ "@" ] [ "_" ] name;
        value = makeHomeConfiguration homeImports.${name};
      }) (builtins.attrNames homeImports)
    );
  };
}
