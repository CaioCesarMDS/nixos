{ ... }:

{
  wayland.windowManager.hyprland.settings.config = {
    general = {
      border_size = 0;
      gaps_in = 3;
      gaps_out = 10;

      allow_tearing = true;
      layout = "dwindle";
    };

    dwindle = {
      preserve_split = true;
      force_split = 2;
    };

    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 0.8;

      shadow = {
        enabled = false;
        range = 10;
        render_power = 2;
        color = "rgba(1a1a1aee)";
      };

      blur = {
        enabled = true;
        size = 6;
        passes = 2;
        xray = true;
        noise = 0.05;
        popups = true;
      };
    };

    ecosystem = {
      no_donation_nag = true;
      no_update_news = true;
    };

    xwayland = {
      force_zero_scaling = true;
    };

    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      font_family = "JetBrainsNerdFont Mono";
      focus_on_activate = true;
      close_special_on_empty = true;
      enable_swallow = true;
      swallow_regex = ".*(kitty|alacritty|foot|wezterm).*";
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };
  };
}
