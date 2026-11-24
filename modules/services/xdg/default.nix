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
  inherit (cfg) browser;
  mediaPlayer = "mpv.desktop";
  pdfViewer = "org.pwmt.zathura-pdf-mupdf.desktop";
  archiveApp = "org.gnome.FileRoller.desktop";

  videoMimeTypes = [
    "video/H264"
    "video/x-msvideo"
    "video/mp4"
    "video/mpeg"
    "video/ogg"
    "video/mp2t"
    "video/webm"
    "video/3gpp"
    "video/3gpp2"
    "video/x-matroska"
    "video/quicktime"
  ];

  audioMimeTypes = [
    "audio/mpeg"
    "audio/flac"
    "audio/x-flac"
    "audio/ogg"
    "audio/opus"
    "audio/wav"
    "audio/x-wav"
    "audio/aac"
    "audio/mp4"
    "audio/x-m4a"
    "audio/webm"
  ];

  archiveMimeTypes = [
    "application/x-7z-compressed"
    "application/zip"
    "application/vnd.rar"
    "application/x-bzip"
    "application/x-bzip2"
    "application/x-tar"
    "application/gzip"
    "application/x-xz"
    "application/zstd"
    "application/x-compressed-tar"
    "application/x-xz-compressed-tar"
  ];

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
      "application/pdf" = pdfViewer;
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
    }
    // genAttrs (videoMimeTypes ++ audioMimeTypes) (_: mediaPlayer)
    // genAttrs archiveMimeTypes (_: archiveApp)
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
  options.cnix.services.xdg = {
    enable = mkEnableOption "XDG base dirs, user dirs, MIME defaults, and session vars";
    browser = mkOption {
      type = types.str;
      example = "firefox.desktop";
      description = "Desktop file that opens web content (set per host in modules.nix).";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.xdg-utils];
    environment.sessionVariables.XDG_CACHE_HOME = "$HOME/.local/cache";
    systemd.user.tmpfiles.users = genAttrs acct.defaultUsers (_: {rules = userDirRules;});

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
  };
}
