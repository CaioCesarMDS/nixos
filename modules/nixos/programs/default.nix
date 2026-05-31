{ lib, vars, ... }:

{
  imports = [
    ./thunar.nix
  ]
  ++ lib.optionals vars.enableGaming [
    ./steam.nix
  ];
}
