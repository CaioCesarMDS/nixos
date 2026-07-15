{ ... }:
{
  den.aspects.kitty.homeManager =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        enableGitIntegration = true;
        shellIntegration.enableZshIntegration = true;
        settings = {
          font_family = "JetBrainsMono Nerd Font";
          font_size = 12;
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
          allow_remote_control = true;

          background = "#1f1f1f";
          foreground = "#bbbbbb";
          selection_background = "#383838";
          selection_foreground = "#f5f5f5";
          url_color = "#ffab70";
          cursor = "#79b8ff";
          cursor_text_color = "#1f1f1f";

          active_tab_background = "#1f1f1f";
          active_tab_foreground = "#fafafa";
          inactive_tab_background = "#1a1a1a";
          inactive_tab_foreground = "#727272";

          color0 = "#1a1a1a";
          color8 = "#5c5c5c";
          color1 = "#f87583";
          color9 = "#ff7a84";
          color2 = "#139F6F";
          color10 = "#79b8ff";
          color3 = "#fed600";
          color11 = "#ffab70";
          color4 = "#79b8ff";
          color12 = "#79b8ff";
          color5 = "#b392f0";
          color13 = "#b392f0";
          color6 = "#c2855a";
          color14 = "#ffab70";
          color7 = "#bbbbbb";
          color15 = "#f8f8f8";
        };
      };
    };
}
