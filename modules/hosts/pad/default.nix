{
  den.aspects.pad = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ ./_hardware-configuration.nix ];

        boot = {
          kernelParams = [
            "radeon.si_support=0"
            "amdgpu.si_support=1"
          ];
        };
        hardware = {
          graphics = {
            enable = true;
            extraPackages = with pkgs; [
              libva
              libva-utils
              libvdpau-va-gl
            ];
          };
        };
        services = {
          xserver = {
            videoDrivers = [ "amdgpu" ];
            xkb = {
              layout = "br";
              variant = "";
            };
          };
          power-profiles-daemon.enable = true;
        };

        # time.timeZone = "America/Sao_Paulo";          # uncomment to override the default (America/Recife)
        # i18n.defaultLocale = "pt_BR.UTF-8";           # uncomment to override the default (en_US.UTF-8)
        # boot.kernelPackages = pkgs.linuxPackages;     # uncomment to override the default (linuxPackages_zen)
        # boot.loader.timeout = 10;                     # uncomment to override the default (30)
        # boot.loader.grub.useOSProber = false;         # uncomment to override the default (true)
        # documentation.nixos.enable = true;            # uncomment to override the default (false)
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
