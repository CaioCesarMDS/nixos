{ ... }:
{
  den.aspects.kitty.homeManager =
    { pkgs, ui, ... }:
    {
      programs.kitty = {
        enable = true;
        enableGitIntegration = true;
        shellIntegration = {
          enableBashIntegration = true;
          enableFishIntegration = true;
          enableZshIntegration = true;
        };
        settings = {
          font_family = "${ui.font.mono}";
          wheel_scroll_min_lines = 1;
          window_padding_width = 4;
          confirm_os_window_close = 0;
          scrollback_lines = 10000;
          enable_audio_bell = false;
          mouse_hide_wait = 30;
          cursor_trail = 1;
          tab_fade = 1;
          active_tab_font_style = "bold";
          inactive_tab_font_style = "bold";
          tab_bar_edge = "top";
          tab_bar_margin_width = 0;
          tab_bar_style = "powerline";
          enabled_layouts = "splits";
          open_url_with_default = true;
          detect_urls = true;
        };
      };
      home.sessionVariables.TERMINAL = "kitty";

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/terminal" = "kitty.desktop";
      };
    };
}
