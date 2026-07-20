{ ... }:
{
  den.aspects.zathura.homeManager =
    { pkgs, ... }:
    {
      programs.zathura = {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
          window-title-basename = true;
          statusbar-h-padding = 0;
          statusbar-v-padding = 0;
          page-padding = 1;
          recolor = false;
          adjust-open = "best-fit";
        };
        mappings = {
          "<C-i>" = "recolor";
          D = "toggle_page_mode";
          "<Right>" = "navigate next";
          "<Left>" = "navigate previous";
          "[fullscreen] <C-i>" = "zoom in";
          "[fullscreen] <C-o>" = "zoom out";
        };
        extraConfig = ''
          set font "JetBrainsMono Nerd Font 11"
        '';
      };

      xdg = {
        mimeApps.defaultApplications = {
          "application/pdf" = "org.pwmt.zathura.desktop";
        };

        dataFile."applications/org.pwmt.zathura.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Name=Zathura
          Exec=zathura %U
          NoDisplay=true
        '';
      };
    };

}
