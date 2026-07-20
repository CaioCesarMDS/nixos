{ ... }:
{
  den.aspects.qbittorrent.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.qbittorrent ];
  };
}
