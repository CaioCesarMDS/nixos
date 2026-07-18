{
  den.aspects.pad = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ ./_hardware-configuration.nix ];

        networking.hostName = "pad";
        boot.kernelParams = [
          "radeon.si_support=0"
          "amdgpu.si_support=1"
        ];
        hardware.graphics.extraPackages = with pkgs; [
          libva
          libva-utils
          libvdpau-va-gl
        ];
        services.xserver.videoDrivers = [ "amdgpu" ];
        services.xserver.xkb = {
          layout = "br";
          variant = "";
        };
        services.power-profiles-daemon.enable = true;
      };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          brightnessctl
        ];

        wayland.windowManager.hyprland.settings = {
          monitor = [
            {
              output = "eDP-1";
              mode = "1920x1080@60";
              position = "0x0";
              scale = "1.0";
            }
          ];

          config.input = {
            kb_layout = "br";
            kb_variant = "";

            touchpad = {
              natural_scroll = false;
              disable_while_typing = true;
            };
          };
        };
      };
  };
}
