{ den, ... }:
{
  den.aspects.station = {
    includes = [
      den.aspects.ly
      den.aspects.ollama
      # den.aspects.libvirt
      den.aspects.gaming
    ];

    nixos =
      { config, pkgs, ... }:
      {
        imports = [ ./_hardware-configuration.nix ];

        boot = {
          kernelModules = [
            "nvidia"
            "nvidia_modeset"
            "nvidia_uvm"
            "nvidia_drm"
          ];
          kernelParams = [
            "nvidia-drm.modeset=1"
            "nvidia_drm.fbdev=1"
          ];
        };
        hardware = {
          nvidia = {
            open = true;
            modesetting.enable = true;
            powerManagement.enable = true;
            nvidiaSettings = false;
            package = config.boot.kernelPackages.nvidiaPackages.latest;
          };
          graphics = {
            enable = true;
            extraPackages = with pkgs; [
              nvidia-vaapi-driver
              libva-vdpau-driver
              libvdpau-va-gl
            ];
          };
        };
        services = {
          xserver = {
            videoDrivers = [ "nvidia" ];
            xkb = {
              layout = "us";
              variant = "intl";
            };
          };

          ollama.package = pkgs.ollama-cuda;
        };

        # time.timeZone = "America/Sao_Paulo";          # uncomment to override the default (America/Recife)
        # i18n.defaultLocale = "pt_BR.UTF-8";           # uncomment to override the default (en_US.UTF-8)
        # boot.kernelPackages = pkgs.linuxPackages;     # uncomment to override the default (linuxPackages_zen)
        # boot.loader.timeout = 10;                     # uncomment to override the default (30)
        # boot.loader.grub.useOSProber = false;         # uncomment to override the default (true)
        # documentation.nixos.enable = true;            # uncomment to override the default (false)

        # users.users.caiocsx.extraGroups = [ "libvirtd" ];
      };

    provides.to-users.homeManager =
      { lib, ... }:
      {
        wayland.windowManager.hyprland = {
          extraConfig = lib.mkAfter ''
            -- --- Nvidia Env Vars ---
            hl.env("GBM_BACKEND", "nvidia-drm")
            hl.env("LIBVA_DRIVER_NAME", "nvidia")
            hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
            hl.env("__GL_GSYNC_ALLOWED", "1")
            hl.env("__GL_VRR_ALLOWED", "1")
            hl.env("__GL_MaxFramesAllowed", "1")
          '';

          settings = {
            monitor = [
              {
                output = "HDMI-A-1";
                mode = "1920x1080@180";
                position = "0x0";
                scale = "1.0";
              }
            ];

            config.input = {
              kb_layout = "us";
              kb_variant = "intl";
            };
          };
        };
      };
  };
}
