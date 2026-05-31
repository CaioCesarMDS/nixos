{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.extraPackages = with pkgs; [
    libva
    libva-utils
    libvdpau-va-gl
  ];
}
