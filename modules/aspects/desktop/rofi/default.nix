{ den, ... }:
{
  den.aspects.rofi = {
    includes = [
      den.aspects.power-menu
      den.aspects.launcher
      den.aspects.clipboard-manager
      den.aspects.network-manager
      den.aspects.wallpaper-picker
    ];

    homeManager =
      { pkgs, ... }:
      {
        imports = [ ./config/_default.nix ];

        programs.rofi = {
          enable = true;
        };
      };
  };
}
