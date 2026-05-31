{ lib, pkgs, vars, ... }:

{
  boot = lib.mkMerge [
    {
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
    }
    (lib.mkIf (vars.gpu == "nvidia") {
      kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia_drm.fbdev=1"
      ];
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    })
    (lib.mkIf (vars.gpu == "amd") {
      kernelParams = [
        "radeon.si_support=0"
        "amdgpu.si_support=1"
      ];
    })
  ];
}
