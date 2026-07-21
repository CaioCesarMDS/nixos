{ ... }:
{
  den.aspects.libvirt.nixos =
    { pkgs, ... }:
    {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      environment.systemPackages = with pkgs; [
        virt-viewer
        qemu
      ];
    };
}
