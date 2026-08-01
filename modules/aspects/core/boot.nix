{ ... }:
{
  den.aspects.boot.nixos =
    { lib, pkgs, ... }:
    {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
        loader = {
          timeout = lib.mkDefault 30;
          grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = lib.mkDefault true;
            configurationLimit = 10;
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };
        supportedFilesystems = [
          "ntfs"
          "exfat"
          "vfat"
          "btrfs"
        ];
        tmp = {
          cleanOnBoot = true;
          useTmpfs = true;
        };
      };
    };
}
