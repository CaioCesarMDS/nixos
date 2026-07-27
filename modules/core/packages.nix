{ ... }:
{
  den.aspects.core-packages.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        curl
        wget
        nano
        psmisc
        xdg-utils
        util-linux
        procps
        pciutils
        usbutils
        hwinfo
        lm_sensors
      ];
    };
}
