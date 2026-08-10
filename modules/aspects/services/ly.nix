{ ... }:
{
  den.aspects.ly.nixos =
    { pkgs, ... }:
    {
      services.displayManager = {
        defaultSession = "hyprland";
        ly = {
          enable = true;
          x11Support = false;
          settings = {
            animation = "matrix"; # colormix, doom, gameoflife
            clock = "%H:%M";
            hide_borders = true;
            hide_key_hints = false;
            save = true;
            load = true;
            bigclock = true;
            default_input = "password";
            clear_password = true;
          };
        };
      };
    };
}
