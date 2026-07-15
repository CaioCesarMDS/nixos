{ ... }:
{
  den.aspects.xdg.homeManager =
    { config, pkgs, ... }:
    let
      home = config.home.homeDirectory;
    in
    {
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;

          documents = "${home}/Documents";
          download = "${home}/Downloads";
          music = "${home}/Music";
          pictures = "${home}/Pictures";
          videos = "${home}/Videos";

          extraConfig = {
            PROJECTS = "${home}/Projects";
            WALLPAPERS = "${home}/Pictures/Wallpapers";
          };
        };
        mimeApps = {
          enable = true;
          defaultApplications = {
            # Browser / Web
            "x-scheme-handler/http" = "zen.desktop";
            "x-scheme-handler/https" = "zen.desktop";
            "x-scheme-handler/chrome" = "zen.desktop";

            "application/xhtml+xml" = "zen.desktop";
            "application/pdf" = "zen.desktop";

            # File Manager
            "inode/directory" = "thunar.desktop";
            "application/x-directory" = "thunar.desktop";

            # Text / Code
            "text/plain" = "codium.desktop";
            "text/markdown" = "codium.desktop";
            "application/json" = "codium.desktop";
            "text/css" = "codium.desktop";
            "text/html" = "codium.desktop";

            # Terminal
            "x-scheme-handler/terminal" = "kitty.desktop";

            # Video / Audio
            "video/mp4" = "mpv.desktop";
            "video/x-matroska" = "mpv.desktop";
            "video/webm" = "mpv.desktop";
            "video/ogg" = "mpv.desktop";
            "video/quicktime" = "mpv.desktop";
            "video/x-flv" = "mpv.desktop";
            "video/x-msvideo" = "mpv.desktop";
            "video/x-ms-wmv" = "mpv.desktop";
            "video/mpeg" = "mpv.desktop";
            "audio/flac" = "mpv.desktop";
            "audio/mpeg" = "mpv.desktop";
            "audio/ogg" = "mpv.desktop";

            # Images
            "image/jpeg" = "imv.desktop";
            "image/png" = "imv.desktop";
            "image/gif" = "imv.desktop";
            "image/svg+xml" = "imv.desktop";
            "image/webp" = "imv.desktop";
            "image/heif" = "imv.desktop";

            # Torrents
            "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
            "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
          };
        };
      };
    };
}
