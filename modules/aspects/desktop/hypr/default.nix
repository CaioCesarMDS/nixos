{ den, ... }:
{
  den.aspects.hyprland-suite = {
    includes = [
      den.aspects.hyprland
      den.aspects.hypridle
      den.aspects.hyprlock
      den.aspects.hyprsunset
    ];

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        hyprshot
        hyprpicker
      ];

      services.polkit-gnome.enable = true;
    };
  };
}
