{ pkgs, ... }:

{
  imports = [
    ./eza.nix
    ./fzf.nix
    ./packages.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];
}
