{ pkgs, ... }:

let
  hyprlockNetwork = pkgs.writeShellApplication {
    name = "hyprlock-network";
    runtimeInputs = with pkgs; [
      coreutils
      networkmanager
      gnugrep
      gawk
    ];
    text = ''
      output=""

      check_network() {
        local status strength level icon
        status="$(nmcli general status | grep -oh '\w*connect\w*')"

        case "$status" in
          disconnected) output+="󰤮" ;;
          connecting) output+="󱍸" ;;
          connected)
            strength="$(nmcli -t -f ACTIVE,SIGNAL dev wifi | awk -F: '/^yes/{print $2}')"
            if [[ -n "$strength" ]]; then
              level=$((strength / 25))
              case $level in
                0) icon="󰤯" ;;
                1) icon="󰤟" ;;
                2) icon="󰤢" ;;
                3) icon="󰤥" ;;
                4) icon="󰤨" ;;
                *) icon="󰤨" ;;
              esac
              output+="$icon"
            else
              output+="󰈀"
            fi
            ;;
        esac
      }

      check_network
      echo "$output"
    '';
  };
in
{
  home.packages = [ hyprlockNetwork ];
}
