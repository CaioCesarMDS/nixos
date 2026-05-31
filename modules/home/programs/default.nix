{ pkgs, ... }:

{
  imports = [
    ./btop.nix
    ./fastfetch.nix
    ./git.nix
    ./kitty.nix
    ./mpv.nix
    ./packages.nix
    ./spicetify.nix
    ./vesktop.nix
    ./zen-browser.nix
  ];
}
