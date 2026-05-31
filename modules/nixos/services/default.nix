{ lib, vars, ... }:

{
  imports = [
    ./dbus.nix
    ./flatpak.nix
    ./pipewire.nix
    ./power.nix
    ./time.nix
    ./xdg-portal.nix
  ]
  ++ lib.optionals vars.enableOllama [
    ./ollama.nix
  ]
  ++ lib.optionals (vars.displayManager != "tty") [
    ./display-manager.nix
  ];
}
