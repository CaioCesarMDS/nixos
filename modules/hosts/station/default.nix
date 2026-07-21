{ den, ... }:
{
  den.aspects.station = {
    includes = [
      den.aspects.ollama
      den.aspects.libvirt
      den.aspects.gaming
    ];

    nixos =
      { config, pkgs, ... }:
      {
        # imports = [ ./_hardware-configuration.nix ];
        
        networking.hostName = "station";
        boot.kernelParams = [
          "nvidia-drm.modeset=1"
          "nvidia_drm.fbdev=1"
        ];
        boot.kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        hardware = {
          nvidia = {
            open = true;
            modesetting.enable = true;
            powerManagement.enable = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.latest;
          };
          graphics = {
            extraPackages = with pkgs; [
              nvidia-vaapi-driver
              libva-vdpau-driver
              libvdpau-va-gl
            ];
          };
        };
        services.xserver.videoDrivers = [ "nvidia" ];
        services.xserver.xkb = {
          layout = "us";
          variant = "intl";
        };
        services.ollama.package = pkgs.ollama-cuda;
        users.users.caiocsx.extraGroups = [ "libvirtd" ];
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
                output = "DP-1";
                mode = "1920x1080@165";
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
