{ lib, vars, ... }:

{
  imports = [
    ./docker.nix
  ]
  ++ lib.optionals vars.enableVirtualMachines [
    ./libvirt.nix
  ];
}
