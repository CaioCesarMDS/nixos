{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      {
        match = {
          class = ".*";
        };
        suppress_event = "maximize";
      }
      {
        match = {
          class = "^$";
          title = "^$";
          xwayland = true;
          float = true;
          fullscreen = false;
          pin = false;
        };
        no_focus = true;
      }
    ];
  };
}
