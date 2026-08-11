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
          xarchiver
          ffmpegthumbnailer
          gvfs
          glib
        ];
      };

    homeManager = { ... }: {
      home.sessionVariables.FILE_MANAGER = "thunar";

      xdg = {
        configFile."Thunar/uca.xml".text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
            <action>
              <icon>utilities-terminal</icon>
              <name>Open Terminal Here</name>
              <unique-id>1700000000000</unique-id>
              <command>sh -c '$TERMINAL --working-directory "$1"' _ %f</command>
              <description>Open terminal in this folder</description>
              <patterns>*</patterns>
              <startup-notify>false</startup-notify>
              <directories/>
            </action>
            <action>
              <icon>accessories-text-editor</icon>
              <name>Edit File</name>
              <unique-id>1700000000001</unique-id>
              <command>sh -c '$TERMINAL -e $EDITOR "$1"' _ %f</command>
              <description>Edit file with default editor</description>
              <patterns>*</patterns>
              <startup-notify>false</startup-notify>
              <text-files/>
            </action>
          </actions>
        '';

        mimeApps.defaultApplications = {
          "inode/directory" = "thunar.desktop";
          "application/x-directory" = "thunar.desktop";

          "application/zip" = "xarchiver.desktop";
          "application/x-zip-compressed" = "xarchiver.desktop";
          "application/x-7z-compressed" = "xarchiver.desktop";
          "application/x-rar" = "xarchiver.desktop";
          "application/x-tar" = "xarchiver.desktop";
          "application/x-gzip" = "xarchiver.desktop";
          "application/x-bzip2" = "xarchiver.desktop";
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
