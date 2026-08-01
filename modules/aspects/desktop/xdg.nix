{ ... }:
{
  den.aspects.xdg.homeManager =
    { config, ... }:
    let
      home = config.home.homeDirectory;
    in
    {
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;
          desktop = null;
          templates = null;
          publicShare = null;
          extraConfig = {
            PROJECTS = "${home}/Projects";
            WALLPAPERS = "${home}/Pictures/Wallpapers";
          };
        };
        mimeApps.enable = true;
      };
    };
}
