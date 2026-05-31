{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    cmatrix
    eza
    fd
    ripgrep
  ];
}
