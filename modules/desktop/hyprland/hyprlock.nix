{ ... }:
{
  den.aspects.hyprlock.homeManager =
    { pkgs, ... }:
    let
      hyprlockSong = pkgs.writeShellApplication {
        name = "hyprlock-song";
        runtimeInputs = with pkgs; [
          playerctl
          coreutils
        ];
        text = ''
          output=""
          MAX_LENGTH=40

          check_song() {
            local players player_name player_status icon title artist info len

            players="$(playerctl -l 2>/dev/null || true)"

            for player_name in $players; do
              player_status="$(playerctl -p "$player_name" status 2>/dev/null || true)"

              if [[ "$player_status" != "Playing" ]]; then
                continue
              fi

              case "$player_name" in
                spotify) icon="󰓇" ;;
                firefox) icon="󰈹" ;;
                mpd) icon="󰎆" ;;
                chromium) icon="󰊯" ;;
                *) icon="" ;;
              esac

              title="$(playerctl -p "$player_name" metadata title 2>/dev/null || true)"
              artist="$(playerctl -p "$player_name" metadata artist 2>/dev/null || true)"

              info="$title  $icon  $artist"
              len=''${#info}

              if (( len > MAX_LENGTH )); then
                info="''${info:0:MAX_LENGTH-3}…"
              fi

              output+="$info "
              break
            done
          }

          check_song
          echo "$output"
        '';
      };

      hyprlockLayout = pkgs.writeShellApplication {
        name = "hyprlock-layout";
        runtimeInputs = with pkgs; [
          coreutils
          jq
        ];
        text = ''
          output=""

          check_layout() {
            data=$(hyprctl devices -j 2>/dev/null)

            layout=$(echo "$data" | jq -r '.keyboards[] | select(.main==true) | .layout')
            variant=$(echo "$data" | jq -r '.keyboards[] | select(.main==true) | .variant')

            layout=$(echo "$layout" | tr '[:lower:]' '[:upper:]')
            variant=$(echo "$variant" | tr '[:lower:]' '[:upper:]')

            if [[ -n "$layout" && "$layout" != "null" ]]; then
              output+="$layout"

              if [[ -n "$variant" && "$variant" != "null" ]]; then
                output+="/$variant"
              fi
            else
              output+="UNK"
            fi
          }

          check_layout
          echo "$output"
        '';
      };

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

      hyprlockLock = pkgs.writeShellApplication {
        name = "hyprlock-lock";
        runtimeInputs = with pkgs; [
          coreutils
        ];
        text = ''
          output=""

          check_lock() {
            local type="$1"
            local label="$2"

            for led in /sys/class/leds/input*::"$type"/brightness; do
              if [[ -f "$led" ]] && [[ "$(cat "$led")" == "1" ]]; then
                output+="$label "
                break
              fi
            done
          }

          check_lock "capslock" "Caps 󰪛"
          check_lock "numlock" "Num "

          echo "$output"
        '';
      };
    in
    {
      home.packages = [
        hyprlockSong
        hyprlockLayout
        hyprlockNetwork
        hyprlockBattery
        hyprlockLock
      ];

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
    };
}
