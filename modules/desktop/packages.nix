{ ... }:
{
  den.aspects.desktop-packages.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pavucontrol
        playerctl
        networkmanagerapplet
        imagemagick
        ffmpeg
        jq
        tree
        nixfmt
        nh
        p7zip
        unzip
        zip
        gnutar
      ];
    };
}
