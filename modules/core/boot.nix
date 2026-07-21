{ ... }:
{
  den.aspects.boot.nixos =
    { pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        loader = {
          timeout = 45;
          grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = true;
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
          tmpfsSize = "20%";
        };
      };
    };
}
