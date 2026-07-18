{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.services.xdg;
  acct = config.cnix.settings.accounts;

  fileManager = "org.gnome.Nautilus.desktop";
  imageManager = "swayimg.desktop";
  textEditor = "Helix.desktop";
  browser =
    if
      builtins.elem config.networking.hostName [
        "kima"
        "bunk"
      ]
    then "zen.desktop"
    else "firefox.desktop";

  videoApps = [
    "mpv.desktop"
    "vlc.desktop"
  ];
  archiveApp = "org.gnome.FileRoller.desktop";

  textEditorMimeTypes = [
    "text/plain"
    "text/markdown"
    "text/x-markdown"
    "text/csv"
    "text/css"
    "text/x-log"
    "text/x-readme"
    "text/x-makefile"
    "text/x-cmake"
    "text/x-python"
    "text/x-script.python"
    "text/x-shellscript"
    "text/x-c"
    "text/x-c++"
    "text/x-csrc"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-c++hdr"
    "text/x-java"
    "text/x-go"
    "text/x-rust"
    "text/x-lua"
    "text/x-perl"
    "text/x-ruby"
    "text/x-php"
    "text/x-haskell"
    "text/x-nix"
    "text/x-tex"
    "text/x-diff"
    "text/x-patch"
    "text/x-ini"
    "text/x-properties"
    "text/x-yaml"
    "text/yaml"
    "text/toml"
    "text/x-toml"
    "application/x-yaml"
    "application/yaml"
    "application/toml"
    "application/x-shellscript"
    "application/javascript"
    "application/x-javascript"
    "application/typescript"
    "application/x-perl"
    "application/x-php"
    "application/x-ruby"
    "application/sql"
    "application/x-desktop"
    "application/x-nix"
  ];

  defaultApplications =
    {
      "text/html" = browser;
      "text/xml" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/chrome" = browser;
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/x-extension-xhtml" = browser;
      "application/x-extension-xht" = browser;
      "application/xhtml+xml" = browser;
      "application/json" = browser;
      "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
      "inode/directory" = fileManager;

      "image/apng" = imageManager;
      "image/avif" = imageManager;
      "image/bmp" = imageManager;
      "image/gif" = imageManager;
      "image/jpeg" = imageManager;
      "image/png" = imageManager;
      "image/svg+xml" = imageManager;
      "image/tiff" = imageManager;
      "image/webp" = imageManager;

      "video/H264" = videoApps;
      "video/x-msvideo" = videoApps;
      "video/mp4" = videoApps;
      "video/mpeg" = videoApps;
      "video/ogg" = videoApps;
      "video/mp2t" = videoApps;
      "video/webm" = videoApps;
      "video/3gpp" = videoApps;
      "video/3gpp2" = videoApps;

      "application/x-7z-compressed" = archiveApp;
      "application/zip" = archiveApp;
      "application/vnd.rar" = archiveApp;
      "application/x-bzip" = archiveApp;
      "application/x-bzip2" = archiveApp;
      "application/x-tar" = archiveApp;
      "application/gzip" = archiveApp;
    }
    // genAttrs textEditorMimeTypes (_: textEditor);

  mimeValueString = v: let
    items =
      if builtins.isList v
      then v
      else [v];
  in
    concatStringsSep ";" items + ";";

  toMimeAppsList = generators.toINI {
    mkKeyValue = generators.mkKeyValueDefault {mkValueString = mimeValueString;} "=";
  };

  userDirsText = ''
    XDG_DESKTOP_DIR="$HOME/desktop"
    XDG_DOCUMENTS_DIR="$HOME/documents"
    XDG_DOWNLOAD_DIR="$HOME/downloads"
    XDG_MUSIC_DIR="$HOME/media/music"
    XDG_PICTURES_DIR="$HOME/media/images"
    XDG_PUBLICSHARE_DIR="$HOME/documents/share"
    XDG_TEMPLATES_DIR="$HOME/documents/templates"
    XDG_VIDEOS_DIR="$HOME/media/videos"
  '';

  userDirRules = map (p: "d ${p} 0700 - - -") [
    "%h/desktop"
    "%h/documents"
    "%h/documents/share"
    "%h/documents/templates"
    "%h/downloads"
    "%h/media"
    "%h/media/images"
    "%h/media/music"
    "%h/media/videos"
    "%h/.local/cache"
  ];
in {
  options.cnix.services.xdg.enable =
    mkEnableOption "XDG base dirs, user dirs, MIME defaults, and session vars";

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [pkgs.xdg-utils];
      environment.sessionVariables.XDG_CACHE_HOME = "$HOME/.local/cache";
      systemd.user.tmpfiles.rules = userDirRules;

      hjem.users = genAttrs acct.defaultUsers (_: {
        files = {
          ".config/user-dirs.dirs" = {
            text = userDirsText;
            clobber = true;
          };

          ".config/mimeapps.list" = {
            generator = toMimeAppsList;
            value = {
              "Default Applications" = defaultApplications;
            };
            clobber = true;
          };
        };
      });
    }

    (mkIf config.cnix.programs.hyprland.enable {
      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
      };
    })
  ]);
}
