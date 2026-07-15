{ lib, ... }:
{
  den.aspects.pad.nixos =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/3523cd6c-396e-447e-b3b0-f94f6040f14c";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/3523cd6c-396e-447e-b3b0-f94f6040f14c";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

      fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/3523cd6c-396e-447e-b3b0-f94f6040f14c";
        fsType = "btrfs";
        options = [ "subvol=@nix" ];
      };

      fileSystems."/var/log" = {
        device = "/dev/disk/by-uuid/3523cd6c-396e-447e-b3b0-f94f6040f14c";
        fsType = "btrfs";
        options = [ "subvol=@log" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/F6C1-301D";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
