{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        on_unlock_cmd = "hyprctl hyprsunset gamma 100";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "hyprctl hyprsunset gamma 50";
          on-resume = "hyprctl hyprsunset gamma 100";
        }
        {
          timeout = 1800;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 3600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && hyprctl hyprsunset gamma 100";
        }
        {
          timeout = 4200;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
