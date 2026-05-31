{ pkgs, ... }:

let
  hyprlockBattery = pkgs.writeShellApplication {
    name = "hyprlock-battery";
    runtimeInputs = with pkgs; [
      coreutils
      procps
    ];
    text = ''
      output=""

      check_battery() {
        local BAT_PATH=""
        local status capacity icon

        for BAT_PATH in /sys/class/power_supply/BAT*; do
          if [[ -d "$BAT_PATH" ]]; then
            break
          fi
          BAT_PATH=""
        done

        if [[ -z "$BAT_PATH" || ! -d "$BAT_PATH" ]]; then
          output+=" 100%"
          return
        fi

        status="$(cat "$BAT_PATH/status")"
        capacity="$(cat "$BAT_PATH/capacity")"

        case $((capacity / 9)) in
          0) icon="󰂎" ;;
          1) icon="󰁺" ;;
          2) icon="󰁻" ;;
          3) icon="󰁼" ;;
          4) icon="󰁽" ;;
          5) icon="󰁾" ;;
          6) icon="󰁿" ;;
          7) icon="󰂀" ;;
          8) icon="󰂁" ;;
          9 | 10) icon="󰂂" ;;
          *) icon="󰁹" ;;
        esac

        case "$status" in
          Charging) output+="󰂄 $capacity%" ;;
          Full) output+="󰁹 $capacity%" ;;
          Discharging) output+="$icon $capacity%" ;;
          *) output+=" $capacity%" ;;
        esac
      }

      check_battery
      echo "$output"
    '';
  };
in
{
  home.packages = [ hyprlockBattery ];
}
