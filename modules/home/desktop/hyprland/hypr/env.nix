{ lib, vars, ... }:

let
  mkEnv = key: val: ''hl.env("${key}", "${val}")'';

  baseEnv = [
    # --- Wayland & Ozone ---
    (mkEnv "NIXOS_OZONE_WL" "1")
    (mkEnv "ELECTRON_OZONE_PLATFORM_HINT" "wayland")
    (mkEnv "OZONE_PLATFORM" "wayland")
    (mkEnv "MOZ_ENABLE_WAYLAND" "1")

    # --- Toolkits ---
    (mkEnv "SDL_VIDEODRIVER" "wayland,x11")
    (mkEnv "CLUTTER_BACKEND" "wayland")
    (mkEnv "GDK_BACKEND" "wayland,x11,*")

    # --- Qt ---
    (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
    (mkEnv "QT_QPA_PLATFORMTHEME" "qt5ct")
    (mkEnv "QT_AUTO_SCREEN_SCALE_FACTOR" "1")
    (mkEnv "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")

    # --- XDG ---
    (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
    (mkEnv "XDG_SESSION_TYPE" "wayland")
    (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")

    # --- Cursor ---
    (mkEnv "HYPRCURSOR_THEME" "Bibata-Modern-Ice")
    (mkEnv "HYPRCURSOR_SIZE" "20")
    (mkEnv "XCURSOR_THEME" "Bibata-Modern-Ice")
    (mkEnv "XCURSOR_SIZE" "20")
  ];

  nvidiaEnv = lib.optionals (vars.gpu == "nvidia") [
    (mkEnv "GBM_BACKEND" "nvidia-drm")
    (mkEnv "LIBVA_DRIVER_NAME" "nvidia")
    (mkEnv "__GLX_VENDOR_LIBRARY_NAME" "nvidia")
    (mkEnv "__GL_GSYNC_ALLOWED" "1")
    (mkEnv "__GL_VRR_ALLOWED" "1")
    (mkEnv "__GL_MaxFramesAllowed" "1")
  ];
  envScript = lib.concatStringsSep "\n" (baseEnv ++ nvidiaEnv);
in
{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      -- --- Environment Variables ---
      ${envScript}
    '';
  };
}
