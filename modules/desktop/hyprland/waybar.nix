{ ... }:
{
  den.aspects.waybar.homeManager =
    { config, pkgs, ... }:
    let
      waybarHyprsunset = pkgs.writeShellApplication {
        name = "waybar-hyprsunset";
        runtimeInputs = with pkgs; [
          systemd
          util-linux
          procps
        ];
        text = ''
          if [[ "''${1:-}" != "-t" ]]; then
            if systemctl --user is-active --quiet hyprsunset; then
              printf "󰤄\n"
            else
              printf "\n"
            fi
            exit 0
          fi

          LOCKFILE="/tmp/hyprsunset.lock"
          exec 200>"$LOCKFILE"
          flock -n 200 || exit 1

          if systemctl --user is-active --quiet hyprsunset; then
            systemctl --user stop hyprsunset
          else
            systemctl --user start hyprsunset
          fi

          sleep 0.1
          pkill -RTMIN+1 waybar

          exit 0
        '';
      };

      waybarColorpicker = pkgs.writeShellApplication {
        name = "waybar-colorpicker";
        runtimeInputs = with pkgs; [
          hyprpicker
          wl-clipboard
          libnotify
          coreutils
          gnugrep
          gawk
          procps
        ];
        text = ''
          LOC="${config.home.homeDirectory}/colorpicker"
          LIMIT=10

          mkdir -p "$LOC"
          touch "$LOC/colors"

          case "''${1:-}" in
            -l)
              cat "$LOC/colors"
              exit 0
              ;;

            -j)
              text="$(head -n 1 "$LOC/colors" || true)"
              if ! [[ "$text" =~ ^#[0-9a-fA-F]{6}$ ]]; then
                text="#ffffff"
              fi

              mapfile -t allcolors < <(tail -n +2 "$LOC/colors" | head -n 5)

              tooltip="<b>   HISTÓRICO</b>\n\n"
              tooltip+="-> <b>$text</b>  <span color='$text'></span>  \n"

              for i in "''${allcolors[@]}"; do
                if [[ "$i" =~ ^#[0-9a-fA-F]{6}$ ]]; then
                  tooltip+="   <b>$i</b>  <span color='$i'></span>  \n"
                fi
              done

              tooltip="''${tooltip//$'\n'/\\n}"

              printf "{\"text\":\"<span color='%s'></span>\",\"tooltip\":\"%s\"}\n" "$text" "$tooltip"
              exit 0
              ;;
          esac

          pkill -x hyprpicker 2>/dev/null || true

          color="$(hyprpicker -a 2>/dev/null | grep -Eo '^#[0-9a-fA-F]{6}$' || true)"

          if [[ -z "$color" ]]; then
            exit 1
          fi

          printf "%s" "$color" | wl-copy

          prevColors="$(grep -vFx "$color" "$LOC/colors" 2>/dev/null | head -n $((LIMIT - 1)) || true)"
          { printf "%s\n" "$color"; printf "%s\n" "$prevColors"; } | sed '/^$/d' > "$LOC/colors"

          notify-send -u low -t 2000 "Color Picker" "Copied Color: $color"

          pkill -RTMIN+1 waybar
        '';
      };
    in
    {
      home.packages = [
        waybarHyprsunset
        waybarColorpicker
      ];

      programs.waybar = {
        enable = true;
        settings.main = {
          # --- GENERAL SETTINGS ---
          "layer" = "top";
          "position" = "top";
          # --- MODULES DEFINITION ---
          "modules-left" = [ "group/group-left" ];
          "modules-center" = [ "group/group-center" ];
          "modules-right" = [ "group/group-right" ];
          # --- MODULE LEFT SETTINGS ---
          "group/group-left" = {
            "orientation" = "inherit";
            "modules" = [
              "custom/notification"
              "clock"
              "tray"
            ];
          };
          "custom/notification" = {
            "format" = "";
            "tooltip" = false;
            "on-click" = "swaync-client -t -sw";
            "escape" = true;
          };
          "clock" = {
            "format" = "{:%H:%M:%S}";
            "format-alt" = "{:%A, %B %d, %Y (%R)}  ";
            "tooltip-format" = "<tt><small>{calendar}</small></tt>";
            "calendar" = {
              "mode" = "year";
              "mode-mon-col" = 3;
              "weeks-pos" = "right";
              "on-scroll" = 1;
              "format" = {
                "months" = "<span color='#B392F0'><b>{}</b></span>";
                "days" = "<span color='#CCCCCC'><b>{}</b></span>";
                "weeks" = "<span color='#79B8FF'><b>W{}</b></span>";
                "weekdays" = "<span color='#A0A0A0'><b>{}</b></span>";
                "today" = "<span color='#FF7A84'><b><u>{}</u></b></span>";
              };
            };
            "actions" = {
              "on-click-right" = "mode";
              "on-scroll-up" = "shift_up";
              "on-scroll-down" = "shift_down";
            };
            "interval" = 1;
          };
          "tray" = {
            "icon-size" = 14;
            "spacing" = 10;
          };
          # --- MODULE CENTER SETTINGS ---
          "group/group-center" = {
            "orientation" = "inherit";
            "modules" = [ "hyprland/workspaces" ];
          };
          "hyprland/workspaces" = {
            "format" = "{icon}";
            "format-icons" = {
              "active" = "";
              "default" = "";
              "empty" = "";
            };
            "persistent-workspaces" = {
              "*" = [
                1
                2
                3
                4
                5
              ];
            };
          };
          # --- MODULE RIGHT SETTINGS ---
          "group/group-right" = {
            "orientation" = "inherit";
            "modules" = [
              "group/group-hardware"
              "group/group-tools"
              "group/group-system"
            ];
          };
          "group/group-hardware" = {
            "orientation" = "inherit";
            "drawer" = {
              "transition-duration" = 400;
              "children-class" = "extras";
              "transition-left-to-right" = false;
            };
            "modules" = [
              "custom/hardware"
              "cpu"
              "memory"
              "disk"
              "temperature"
            ];
          };
          "custom/hardware" = {
            "format" = "";
            "tooltip" = false;
          };
          "cpu" = {
            "format" =
              "<span font='JetBrainsMono Nerd Font Mono 15' rise='-2600'>󰍛</span> <span font='JetBrainsMono Nerd Font Mono 9'>{usage}%</span>";
            "tooltip" = true;
            "interval" = 5;
          };
          "memory" = {
            "format" =
              "<span font='JetBrainsMono Nerd Font Mono 15' rise='-2600'></span> <span font='JetBrainsMono Nerd Font Mono 9'>{percentage}%</span>";
            "tooltip" = true;
            "interval" = 5;
          };
          "disk" = {
            "path" = "/";
            "interval" = 30;
            "states" = {
              "warning" = 90;
              "critical" = 95;
            };
            "format" =
              "<span font='JetBrainsMono Nerd Font Mono 15' rise='-2600'></span> <span font='JetBrainsMono Nerd Font Mono 9'>{percentage_used}%</span>";
            "tooltip" = true;
            "tooltip-format" = "Free: {free} / {total} ({percentage_free}%)\nUsed: {used} ({percentage_used}%)";
          };
          "temperature" = {
            "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
            "critical-threshold" = 85;
            "interval" = 10;
            "format" =
              "<span font='JetBrainsMono Nerd Font Mono 11'>{icon}</span> <span font='JetBrainsMono Nerd Font Mono 9' rise='1000'>{temperatureC}°C</span>";
            "format-icons" = [
              "󱃃"
              "󰔏"
              "󱃂"
            ];
            "tooltip-format" = "Temperature: {temperatureC}°C";
          };
          "group/group-tools" = {
            "orientation" = "inherit";
            "drawer" = {
              "transition-duration" = 400;
              "children-class" = "extras";
              "transition-left-to-right" = false;
            };
            "modules" = [
              "custom/tools"
              "custom/cliphist"
              "custom/colorpicker"
              "custom/bluefilter"
            ];
          };
          "custom/tools" = {
            "format" = "";
            "tooltip" = false;
          };
          "custom/cliphist" = {
            "format" = "";
            "tooltip" = false;
            "on-click" = "rofi-clipboard-manager";
            "on-click-right" = "rofi-clipboard-manager -w";
          };
          "custom/colorpicker" = {
            "format" = "{}";
            "return-type" = "json";
            "interval" = "once";
            "tooltip" = true;
            "on-click" = "waybar-colorpicker";
            "exec" = "waybar-colorpicker -j";
            "signal" = 1;
          };
          "custom/bluefilter" = {
            "format" = "{}";
            "tooltip" = false;
            "on-click" = "waybar-hyprsunset -t";
            "exec" = "waybar-hyprsunset";
            "interval" = 1000;
            "signal" = 1;
          };
          "group/group-system" = {
            "orientation" = "inherit";
            "modules" = [
              "bluetooth"
              "network"
              "battery"
              "custom/power"
            ];
          };
          "bluetooth" = {
            "format" = "";
            "format-on" = "";
            "format-disabled" = "󰂲";
            "format-connected-battery" = "󰂯";
            "format-alt" = "{device_alias} 󰂯";
            "tooltip" = true;
            "tooltip-format" = "{device_enumerate}";
            "tooltip-format-enumerate-connected" = "{device_alias}";
            "tooltip-format-enumerate-connected-battery" = "{device_alias} {device_battery_percentage}%";
            "on-click" = "rfkill toggle bluetooth";
            "on-click-right" = "blueman-manager";
          };
          "network" = {
            "format" = "󰖪";
            "format-wifi" = "";
            "format-ethernet" = "󰈀";
            "format-disconnected" = "";
            "tooltip-format-disconnected" = "Error";
            "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
            "tooltip-format-ethernet" = "{ifname} 🖧";
            "on-click" = "rfkill toggle wifi";
            "on-click-right" = "kitty nmtui";
          };
          "battery" = {
            "interval" = 3;
            "states" = {
              "good" = 95;
              "warning" = 30;
              "critical" = 20;
            };
            "format" =
              "<span font='JetBrainsMono Nerd Font Mono 10' >{icon}</span> <span font='JetBrainsMono Nerd Font Mono 9'>{capacity}%</span>";
            "rotate" = 0;
            "format-charging" = "󰂄 {capacity}%";
            "format-plugged" = "󰂄 {capacity}%";
            "format-alt" = "{time} {icon}";
            "format-icons" = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          "custom/power" = {
            "format" = "⏻";
            "tooltip" = false;
            "on-click" = "rofi-powermenu";
            "interval" = "once";
          };
        };
        # --- STYLE ---
        style = ''
          @define-color background #2A2A2A;
          @define-color background-alt #383838;
          @define-color foreground #CCCCCC;
          @define-color foreground-muted #A0A0A0;
          @define-color accent-primary #B392F0;
          @define-color accent-active  #79B8FF;
          @define-color accent-urgent  #FF7A84;
          @define-color accent-warning #FFD866;

          * {
            all: unset;
            border: none;
            box-shadow: none;
            font-size: 1.2rem;
            min-height: 2rem;
            font-family: 'JetBrainsMono Nerd Font Mono', 'monospace';
          }

          window#waybar {
            background-color: transparent;
          }

          tooltip {
            background: @background;
            border: 2px solid @background-alt;
            border-radius: 8px;
          }

          tooltip label {
            color: @foreground;
          }

          #custom-notification:hover,
          #clock:hover,
          #custom-hardware:hover,
          #cpu:hover,
          #memory:hover,
          #disk:hover,
          #temperature:hover,
          #custom-tools:hover,
          #custom-cliphist:hover,
          #custom-bluefilter:hover,
          #bluetooth:hover,
          #network:hover,
          #battery:hover,
          #custom-power:hover {
            transition: all 0.3s ease;
            color: @accent-active;
          }

          /* Modules Left */

          #custom-notification,
          #clock,
          #tray {
            margin: 0.3rem 0 0 0.6rem;
            padding: 0 1rem;
            transition: all 0.3s ease;
            color: @foreground;
            background-color: @background;
            border-radius: 8px;
          }

          #custom-notification {
            font-size: 1.2rem;
          }

          #clock {
            font-size: 0.9rem;
          }

          #tray window decoration {
            padding: 0.5rem 0.8rem;
            background-color: alpha(@background, 0.9);
            border-radius: 8px;
          }

          /* Modules Center */

          #workspaces {
            margin: 0.3rem 0 0 0;
            padding: 0px 0.7rem;
            background-color: @background;
            border-radius: 8px;
          }

          #workspaces button {
            padding: 0 0.4rem;
            color: alpha(@foreground-muted, 0.4);
            transition: all 0.2s ease;
          }

          #workspaces button:hover {
            color: rgba(0, 0, 0, 0);
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.5);
            transition: all 0.5s ease;
          }

          #workspaces button.active {
            color: @foreground-muted;
            text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.5);
          }

          #workspaces button.empty {
            color: rgba(0, 0, 0, 0);
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.2);
          }

          #workspaces button.empty:hover {
            color: rgba(0, 0, 0, 0);
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.5);
            transition: all 0.5s ease;
          }

          #workspaces button.empty.active {
            color: @foreground-muted;
            text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.5);
          }

          /* Modules Right */

          #custom-hardware,
          #custom-tools {
            font-size: 1.3rem;
            margin: 0.3rem 0 0 0.6rem;
            padding: 0 1rem;
            color: @foreground;
            background-color: @background;
            border-radius: 8px;
          }

          /* Left Components*/
          #cpu,
          #custom-cliphist,
          #bluetooth {
            padding-left: 1rem;
            border-bottom-left-radius: 8px;
            border-top-left-radius: 8px;
          }

          /* Rigth Components */
          #temperature,
          #custom-bluefilter,
          #custom-power {
            padding-right: 1rem;
            border-bottom-right-radius: 8px;
            border-top-right-radius: 8px;
          }

          #cpu,
          #memory,
          #disk,
          #temperature,
          #custom-cliphist,
          #custom-colorpicker,
          #custom-bluefilter,
          #bluetooth,
          #network,
          #battery,
          #custom-power {
            margin-top: 0.3rem;
            color: @foreground;
            background-color: @background;
          }

          #memory {
            padding: 0 0.8rem 0 0.8rem;
          }

          #disk {
            padding: 0 0.8rem 0 0;
          }

          #disk.warning {
            color: @accent-warning;
          }

          #disk.critical {
            color: @accent-urgent;
          }

          #temperature.critical {
            color: @accent-urgent;
          }

          #custom-colorpicker {
            padding: 0 0.8rem;
          }

          #custom-cliphist,
          #custom-colorpicker,
          #custom-bluefilter {
            font-size: 1.3rem;
          }

          #custom-cliphist {
            margin-left: 0.6rem;
          }

          #bluetooth,
          #network,
          #battery,
          #custom-power {
            padding: 0 0.7rem;
            background-color: @background;
          }

          #bluetooth {
            margin-left: 0.6rem;
            font-size: 1.1rem;
          }

          #network {
            font-size: 1.5rem;
          }

          #battery {
            font-size: 0.8rem;
          }

          #custom-power {
            margin-right: 0.6rem;
          }
        '';
      };
    };
}
