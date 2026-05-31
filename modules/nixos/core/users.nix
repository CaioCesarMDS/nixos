{ pkgs, lib, vars, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users.${vars.username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ]
      ++ lib.optionals vars.enableVirtualMachines [
        "libvirtd"
      ];
    };
  };
}
