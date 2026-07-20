{ ... }:
{
  den.aspects.thunar = {
    nixos =
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

    homeManager = { ... }: {
      xdg = {
        mimeApps.defaultApplications = {
          "inode/directory" = "thunar.desktop";
          "application/x-directory" = "thunar.desktop";
        };

        dataFile = {
          "applications/thunar-settings.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Thunar Settings
            Exec=true
            NoDisplay=true
          '';
          "applications/thunar-bulk-rename.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Thunar Bulk Rename
            Exec=true
            NoDisplay=true
          '';
          "applications/thunar-volman-settings.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Thunar Volman Settings
            Exec=true
            NoDisplay=true
          '';
        };
      };
    };
  };
}
