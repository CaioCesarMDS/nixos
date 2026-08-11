{ ... }:
{
  den.aspects.wallpapers.homeManager = { pkgs, ... }: {
    imports = [
      ./_services.nix
    ];

    home.packages = with pkgs; [ awww ];
    home.file."Pictures/Wallpapers" = {
      source = ../../../../assets/wallpapers;
      recursive = true;
    };
  };
}
