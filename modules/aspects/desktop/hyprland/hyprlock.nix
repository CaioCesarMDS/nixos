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

      hyprlockStatus = pkgs.writeShellApplication {
        name = "hyprlock-status";
        runtimeInputs = with pkgs; [
          coreutils
          jq
          networkmanager
          iw
          gawk
          procps
        ];
        text = ''
          get_layout() {
            local data layout variant
            data=$(hyprctl devices -j 2>/dev/null || true)
            layout=$(echo "$data" | jq -r '.keyboards[] | select(.main==true) | .layout' 2>/dev/null || true)
            variant=$(echo "$data" | jq -r '.keyboards[] | select(.main==true) | .variant' 2>/dev/null || true)

            layout=$(echo "$layout" | tr '[:lower:]' '[:upper:]')
            variant=$(echo "$variant" | tr '[:lower:]' '[:upper:]')

            if [[ -n "$layout" && "$layout" != "null" ]]; then
              if [[ -n "$variant" && "$variant" != "null" ]]; then
                echo "$layout/$variant "
              else
                echo "$layout "
              fi
            else
              echo "UNK "
            fi
          }

          get_network() {
            local status iface signal icon eth_connected
            status="$(nmcli -t -f STATE general 2>/dev/null || true)"

            case "$status" in
              connected)
                eth_connected="$(nmcli -t -f TYPE,STATE device status 2>/dev/null | awk -F: '$1=="ethernet" && $2=="connected" {print "yes"; exit}')"

                if [[ "$eth_connected" == "yes" ]]; then
                  echo "󰈀"
                else
                  iface="$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$2=="wifi" && $3=="connected"{print $1; exit}')"

                  if [[ -n "$iface" ]]; then
                    signal="$(iw dev "$iface" link 2>/dev/null | awk '/signal:/ {print $2}')"

                    case "$signal" in
                      -[0-5][0-9]|-6[0-4]) icon="󰤨" ;;
                      -6[5-9]|-7[0-4])     icon="󰤥" ;;
                      -7[5-9]|-8[0-4])     icon="󰤢" ;;
                      -8[5-9]|-9[0-4])     icon="󰤟" ;;
                      *)                   icon="󰤯" ;;
                    esac

                    echo "$icon"
                  else
                    echo "󰈀"
                  fi
                fi
                ;;
              connecting)
                echo "󱍸"
                ;;
              *)
                echo "󰤮"
                ;;
            esac
          }

          get_battery() {
            local BAT_PATH="" status capacity icon

            for path in /sys/class/power_supply/BAT*; do
              if [[ -d "$path" ]]; then
                BAT_PATH="$path"
                break
              fi
            done

            if [[ -z "$BAT_PATH" ]]; then
              return
            fi

            status="$(cat "$BAT_PATH/status" 2>/dev/null || true)"
            capacity="$(cat "$BAT_PATH/capacity" 2>/dev/null || true)"

            case $((capacity / 10)) in
              0) icon="󰂎" ;;
              1) icon="󰁺" ;;
              2) icon="󰁻" ;;
              3) icon="󰁼" ;;
              4) icon="󰁽" ;;
              5) icon="󰁾" ;;
              6) icon="󰁿" ;;
              7) icon="󰂀" ;;
              8) icon="󰂁" ;;
              9) icon="󰂂" ;;
              10) icon="󰁹" ;;
              *) icon="󰁹" ;;
            esac

            case "$status" in
              "Charging")          echo "󰂄 $capacity%" ;;
              "Full")              echo "󰁹 $capacity%" ;;
              *)                   echo "$icon $capacity%" ;;
            esac
          }

          layout_out="$(get_layout)"
          network_out="$(get_network)"
          battery_out="$(get_battery)"

          output="$layout_out    $network_out"
          if [[ -n "$battery_out" ]]; then
            output="$output    $battery_out"
          fi

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
        hyprlockStatus
        hyprlockLock
      ];

      programs.hyprlock =
        let
          font = "JetBrainsMono Nerd Font Propo";
          fontBold = "JetBrainsMono Nerd Font Mono Bold";

          fg = "rgba(229, 229, 229, 1)";
        in
        {
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
                color = fg;
                font_size = 11;
                font_family = font;
                position = "10, 520";
                halign = "left";
                valign = "center";
              }
              {
                monitor = "";
                text = "cmd[update:1000] hyprlock-status";
                color = fg;
                font_size = 11;
                font_family = font;
                position = "-15, 520";
                halign = "right";
                valign = "center";
              }
              {
                monitor = "";
                text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
                color = fg;
                font_size = 20;
                font_family = fontBold;
                position = "0, 405";
                halign = "center";
                valign = "center";
              }
              {
                monitor = "";
                text = "cmd[update:1000] echo \"$(date +\"%k:%M\")\"";
                color = fg;
                font_size = 93;
                font_family = fontBold;
                position = "0, 310";
                halign = "center";
                valign = "center";
              }
              {
                monitor = "";
                text = "Enter Password";
                color = fg;
                font_size = 10;
                font_family = font;
                position = "0, -438";
                halign = "center";
                valign = "center";
              }
              {
                monitor = "";
                text = "cmd[update:100] hyprlock-lock";
                color = fg;
                font_size = 10;
                font_family = font;
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
                font_color = fg;
                font_family = font;
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
