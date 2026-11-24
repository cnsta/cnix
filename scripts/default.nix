{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.cnix.scripts;

  mkScript = name: {
    runtimeInputs,
    file,
  }:
    pkgs.writeShellApplication {
      name = "${name}.sh";
      inherit runtimeInputs;
      text = builtins.readFile file;
    };

  scriptDefs = with pkgs; {
    screenshot = {
      runtimeInputs = with pkgs; [grim slurp wl-clipboard libnotify tesseract coreutils jq procps];
      file = ./bin/screenshot.sh;
    };

    choosepaper = {
      runtimeInputs = [
        fzf
        swaybg
        pistol
      ];
      file = ./bin/choosepaper.sh;
    };

    pwvucontrol-toggle = {
      runtimeInputs = [pwvucontrol];
      file = ./bin/pwvucontrol-toggle.sh;
    };

    extract = {
      runtimeInputs = [
        gnutar
        gzip
        bzip2
        xz
        unzip
        unrar
        p7zip
        cpio
        cabextract
        qpdf
      ];
      file = ./bin/extract.sh;
    };

    update-images = {
      runtimeInputs = [podman];
      file = ./bin/update-images.sh;
    };
  };
in {
  options.cnix.scripts =
    lib.mapAttrs (name: def: {
      enable = lib.mkEnableOption "${name} script";

      package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        default = mkScript name def;
        defaultText = lib.literalMD "built from `./bin/${name}.sh`";
        description = "The built ${name} script.";
      };
    })
    scriptDefs;

  config.environment.systemPackages = lib.pipe scriptDefs [
    (lib.filterAttrs (name: _: cfg.${name}.enable))
    (lib.mapAttrsToList (name: _: cfg.${name}.package))
  ];
}
