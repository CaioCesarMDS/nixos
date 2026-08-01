{ ... }:
{
  den.aspects.qbittorrent.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.qbittorrent ];

    xdg.mimeApps.defaultApplications = {
      "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
    };
  };
}
