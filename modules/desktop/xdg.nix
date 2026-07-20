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
          documents = "${home}/Documents";
          download = "${home}/Downloads";
          music = "${home}/Music";
          pictures = "${home}/Pictures";
          videos = "${home}/Videos";
          extraConfig = {
            PROJECTS = "${home}/Projects";
            WALLPAPERS = "${home}/Pictures/Wallpapers";
          };
        };
        mimeApps.enable = true;
      };
    };
}