{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = [
        {
          monitor = "";
          path = "$HOME/.cache/wallpaper/lockscreen";
          color = "rgba(13, 13, 13, 1)";
          blur_passes = 3;
          blur_size = 2;
          brightness = 0.6;
        }
      ];
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] hyprlock-song";
          color = "rgba(229, 229, 229, 1)";
          font_size = 11;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "10, 520";
          halign = "left";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] hyprlock-layout";
          font_size = 10;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "-150, 520";
          halign = "right";
          valign = "center";
        }
        {
          monitor = "";
          text = " ";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "-130, 520";
          halign = "right";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] hyprlock-network";
          color = "rgba(229, 229, 229, 1)";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "-90, 520";
          halign = "right";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] hyprlock-battery";
          color = "rgba(229, 229, 229, 1)";
          font_size = 11;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "-10, 520";
          halign = "right";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
          color = "rgba(229, 229, 229, 1)";
          font_size = 20;
          font_family = "JetBrainsMono Nerd Font Mono Bold";
          position = "0, 405";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%k:%M\")\"";
          color = "rgba(229, 229, 229, 1)";
          font_size = 93;
          font_family = "JetBrainsMono Nerd Font Mono Bold";
          position = "0, 310";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Enter Password";
          color = "rgba(229, 229, 229, 1)";
          font_size = 10;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "0, -438";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:100] hyprlock-lock";
          color = "rgba(229, 229, 229, 1)";
          font_size = 10;
          font_family = "JetBrainsMono Nerd Font Mono";
          position = "0, -500";
          halign = "center";
          valign = "center";
        }
      ];
      "input-field" = [
        {
          monitor = "";
          size = "200, 30";
          outline_thickness = 0;
          dots_size = 0.25;
          dots_spacing = 0.55;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.2)";
          font_color = "rgba(229, 229, 229, 1)";
          font_family = "JetBrainsMono Nerd Font Mono";
          fade_on_empty = true;
          check_color = "rgba(0, 0, 0, 0.4)";
          fail_text = "$FAIL <b>($ATTEMPTS)</b>";
          position = "0, -468";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
