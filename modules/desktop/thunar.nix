{ ... }:
{
  den.aspects.thunar.nixos =
    { pkgs, ... }:
    {
      programs = {
        thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-archive-plugin
            thunar-volman
          ];
        };
        xfconf.enable = true;
      };

      services = {
        gvfs.enable = true;
        tumbler.enable = true;
      };

      environment.systemPackages = with pkgs; [
        ffmpegthumbnailer
      ];
    };
}
