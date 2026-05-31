{ vars, ... }:

{
  wayland.windowManager.hyprland.settings.config = {
    cursor = {
      hide_on_key_press = true;
      inactive_timeout = 10;
      no_warps = true;
      enable_hyprcursor = true;
    };

    input = {
      kb_layout = vars.keyboardLayout;
      kb_variant = vars.keyboardVariant;
      follow_mouse = true;
      sensitivity = 0;
      force_no_accel = true;

      touchpad = {
        natural_scroll = false;
        disable_while_typing = true;
      };
    };
  };
}
