{ pkgs, ... }:
{
  home.packages = with pkgs; [ awww ];
  home.file."Pictures/Wallpapers" = {
    source = ../../../../assets/wallpapers;
    recursive = true;
  };
}
