{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/desktop
    ../../modules/nixos/hardware
    ../../modules/nixos/programs
    ../../modules/nixos/security
    ../../modules/nixos/services
    ../../modules/nixos/virtualisation
  ];

  system.stateVersion = "25.11";
}
