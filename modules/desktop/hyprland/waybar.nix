{ ... }:
{
  den.aspects.waybar.homeManager =
    { pkgs, ... }:
    {
      programs.waybar = {
        enable = true;
        settings.main = {
          # --- GENERAL SETTINGS ---
          "layer" = "top";
          "position" = "top";
          "margin" = "8px 8px 0 8px";
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
              "privacy"
              "tray"
            ];
          };
          "custom/notification" = {
            "format" = "<span size='12pt'>{icon}</span>";
            "format-icons" = {
              "notification" = "󱅫";
              "none" = "󰂜";
              "dnd-notification" = "󰂠";
              "dnd-none" = "󰪓";
              "inhibited-notification" = "󰂛";
              "inhibited-none" = "󰪑";
              "dnd-inhibited-notification" = "󰂛";
              "dnd-inhibited-none" = "󰪑";
            };
            "exec-if" = "which swaync-client";
            "exec" = "swaync-client -swb";
            "on-click" = "swaync-client -t -sw";
            "on-click-right" = "swaync-client -d -sw";
            "return-type" = "json";
            "tooltip" = true;
            "escape" = true;
          };
          "clock" = {
            "format" = "{:%H:%M:%S}";
            "format-alt" = "{:%H:%M - %B %d, %Y}";
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
          "privacy" = {
            "modules" = [
              {
                "type" = "screenshare";
                "tooltip" = false;
              }
              {
                "type" = "audio-in";
                "tooltip" = false;
              }
              {
                "type" = "location";
                "icon-name" = "location-services-active-symbolic";
              }
            ];
            "icon-size" = 14;
            "icon-spacing" = 10;
            "transition-duration" = 250;
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
              "pulseaudio#microphone"
              "group/audio"
              "group/brightness"
              "group/group-system"
            ];
          };
          "pulseaudio#microphone" = {
            "format" = "{format_source}";
            "format-source" = "<span size='13pt'>󰍬</span>";
            "format-source-muted" = "<span size='13pt'>󰍭</span>";
            "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            "on-scroll-up" = "";
            "on-scroll-down" = "";
            "tooltip" = false;
          };
          "group/audio" = {
            "orientation" = "inherit";
            "drawer" = {
              "children-class" = "audio";
              "transition-left-to-right" = false;
              "transition-duration" = 400;
            };
            "modules" = [
              "pulseaudio"
              "pulseaudio/slider"
            ];
          };
          "pulseaudio/slider" = {
            "orientation" = "horizontal";
            "min" = 0;
            "max" = 100;
          };
          "pulseaudio" = {
            "format" = "{icon}";
            "format-muted" = "<span size='11pt'></span>";
            "format-icons" = {
              "headphone" = "<span size='11pt'>󰋋</span>";
              "headset" = "<span size='11pt'>󰋎</span>";
              "headset-muted" = "<span size='11pt'>󰟎</span>";
              "default" = [
                "<span size='11pt'></span>"
                "<span size='11pt'></span>"
                "<span size='11pt'></span>"
              ];
            };
            "on-click" = "pavucontrol";
            "on-click-right" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "tooltip-format" = "Volume: {volume}%";
            "ignored-sinks" = [ "Easy Effects Sink" ];
            "tooltip" = true;
          };
          "group/brightness" = {
            "orientation" = "inherit";
            "drawer" = {
              "children-class" = "brightness";
              "transition-left-to-right" = false;
              "transition-duration" = 400;
            };
            "modules" = [
              "backlight"
              "backlight/slider"
            ];
          };
          "backlight/slider" = {
            "orientation" = "horizontal";
            "min" = 5;
            "max" = 100;
          };
          "backlight" = {
            "format" = "<span size='11pt'>{icon}</span>";
            "format-icons" = [
              "<span size='11pt'>󰃞</span>"
              "<span size='11pt'>󰃝</span>"
              "<span size='11pt'>󰃟</span>"
              "<span size='11pt'>󰃠</span>"
            ];
            "tooltip-format" = "Brightness: {percent}%";
            "tooltip" = true;
          };
          "group/group-system" = {
            "orientation" = "inherit";
            "modules" = [
              "bluetooth"
              "network"
              "battery"
            ];
          };
          "bluetooth" = {
            "format-on" = "<span size='13pt'>󰂯</span>";
            "format-off" = "<span size='13pt'>󰂲</span>";
            "format-disabled" = "<span size='13pt'>󰂲</span>";
            "format-connected" = "<span size='13pt'>󰂱</span>";
            "format-no-controller" = "<span size='13pt'>󰂯</span>";
            "tooltip-format" = "{device_enumerate}";
            "tooltip-format-enumerate-connected" = "{device_address}";
            "tooltip-format-enumerate-connected-battery" =
              "{device_alias} | Battery {device_battery_percentage}%";
            "on-click" = "blueman-manager";
            "on-click-right" = "rfkill toggle bluetooth";
            "tooltip" = true;
          };
          "network" = {
            "format-icons" = {
              "wifi" = [
                "<span size='12pt'>󰤯</span>"
                "<span size='12pt'>󰤟</span>"
                "<span size='12pt'>󰤢</span>"
                "<span size='12pt'>󰤥</span>"
                "<span size='12pt'>󰤨</span>"
              ];
              "ethernet" = "<span size='12pt'>󰈀</span>";
              "disabled" = "<span size='12pt'>󰤭</span>";
              "disconnected" = "<span size='12pt'>󰤩</span>";
            };
            "format-wifi" = "{icon}";
            "format-ethernet" = "{icon}";
            "format-disconnected" = "{icon}";
            "format-disabled" = "{icon}";
            "tooltip-format-wifi" =
              "{essid}\nSignal: {signalStrength}%\nIP: {ipaddr}/{cidr}\n↓ {bandwidthDownBits}  ↑ {bandwidthUpBits}";
            "tooltip-format-ethernet" = "{ifname}\nIP: {ipaddr}/{cidr}\nGateway: {gwaddr}";
            "tooltip-format-disconnected" = "Disconnected";
            "tooltip-format-disabled" = "Wi-Fi disabled";
            "on-click" = "rofi-network-manager";
            "on-click-right" = "rfkill toggle wifi";
            "tooltip" = true;
            "max-length" = 20;
            "interval" = 5;
          };
          "battery" = {
            "states" = {
              "warning" = 20;
              "critical" = 10;
            };
            "events" = {
              "on-charging" = "notify-send -u normal 'Power' 'Connected to AC power'";
              "on-charging-100" = "notify-send -u normal 'Battery' 'Battery is fully charged'";
              "on-discharging" = "notify-send -u normal 'Power' 'Running on battery'";
              "on-discharging-warning" = "notify-send -u normal 'Battery Warning' 'Battery level is low'";
              "on-discharging-critical" =
                "notify-send -u critical 'Battery Critical' 'Battery level is critically low'";
            };
            "format" = "{icon}";
            "format-icons" = {
              "default" = [
                "<span size='12pt'>󰂎</span>"
                "<span size='12pt'>󰁺</span>"
                "<span size='12pt'>󰁻</span>"
                "<span size='12pt'>󰁼</span>"
                "<span size='12pt'>󰁽</span>"
                "<span size='12pt'>󰁾</span>"
                "<span size='12pt'>󰁿</span>"
                "<span size='12pt'>󰂀</span>"
                "<span size='12pt'>󰂁</span>"
                "<span size='12pt'>󰂂</span>"
                "<span size='12pt'>󰁹</span>"
              ];
              "charging" = [
                "<span size='12pt'>󰢟</span>"
                "<span size='12pt'>󰢜</span>"
                "<span size='12pt'>󰂆</span>"
                "<span size='12pt'>󰂇</span>"
                "<span size='12pt'>󰂈</span>"
                "<span size='12pt'>󰢝</span>"
                "<span size='12pt'>󰂉</span>"
                "<span size='12pt'>󰢞</span>"
                "<span size='12pt'>󰂊</span>"
                "<span size='12pt'>󰂋</span>"
                "<span size='12pt'>󰂅</span>"
              ];
            };
            "format-critical" = "<span size='12pt'>󰂃</span>";
            "tooltip-format" = "{capacity}% - {time} remaining";
            "tooltip-format-charging" = "Charging: {capacity}% - {time} until full";
            "tooltip" = true;
            "interval" = 10;
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
          @define-color accent-success #7EE787;

          @keyframes blink-success {
            from {
              color: @foreground;
            }
            to {
              color: @accent-success;
            }
          }

          @keyframes blink-warning {
            from {
              color: @foreground;
            }
            to {
              color: @accent-warning;
            }
          }

          @keyframes blink-urgent {
            from {
              color: @foreground;
            }
            to {
              color: @accent-urgent;
            }
          }

          * {
            all: unset;
            border: none;
            box-shadow: none;
            min-height: 25px;
            font-size: 1rem;
            font-family: 'JetBrainsMono Nerd Font Propo';
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

          #custom-notification,
          #clock,
          #privacy,
          #tray,
          #pulseaudio.microphone,
          #pulseaudio,
          #backlight,
          #group-system {
            min-width: 25px;
            padding: 0 10px;
            color: @foreground;
            background-color: @background;
            border-radius: 8px;
          }

          #custom-notification:hover,
          #clock:hover,
          #privacy:hover,
          #pulseaudio.microphone:hover,
          #pulseaudio:hover,
          #backlight:hover,
          #bluetooth:hover,
          #network:hover,
          #battery:hover {
            transition: all 0.3s ease;
            color: @accent-active;
          }

          /* Modules Left */
          #custom-notification,
          #clock,
          #privacy,
          #tray {
            margin: 0 4px;
          }

          #clock {
            padding: 0 15px;
          }

          #tray window decoration {
            padding: 6px 12px;
            background-color: alpha(@background, 0.9);
            border-radius: 8px;
          }

          /* Modules Center */
          #workspaces {
            padding: 0px 10px;
            background-color: @background;
            border-radius: 8px;
          }

          #workspaces button {
            padding: 0 5px;
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

          /* Group leaders */
          #pulseaudio.microphone,
          #pulseaudio,
          #backlight,
          #group-system {
            margin: 0 4px;
          }

          #pulseaudio.microphone,
          #pulseaudio,
          #backlight,
          #bluetooth,
          #network,
          #battery {
            padding: 0 8px;
            color: @foreground;
            background-color: @background;
          }

          #pulseaudio-slider,
          #backlight-slider {
            background-color: @background;
            padding: 0 10px;
            border-radius: 8px;
          }

          #pulseaudio-slider slider,
          #backlight-slider slider {
            min-height: 0px;
            min-width: 0px;
          }

          #pulseaudio-slider trough,
          #backlight-slider trough {
            min-height: 8px;
            min-width: 100px;
            border-radius: 8px;
            background-color: @background-alt;
          }

          #pulseaudio-slider highlight,
          #backlight-slider highlight {
            min-width: 8px;
            min-height: 8px;
            border-radius: 8px;
            background: @foreground;
          }

          #battery.charging.warning,
          #battery.charging.critical {
            animation-name: blink-success;
            animation-duration: 2s;
            animation-timing-function: ease-in-out;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          #battery.charging.warning:hover,
          #battery.charging.critical:hover {
            color: @accent-success;
          }

          #battery.warning {
            animation-name: blink-warning;
            animation-duration: 2s;
            animation-timing-function: ease-in-out;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          #battery.warning:hover {
            color: @accent-warning;
          }

          #battery.critical {
            animation-name: blink-urgent;
            animation-duration: 0.8s;
            animation-timing-function: ease-in-out;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          #battery.critical:hover {
            color: @accent-urgent;
          }
        '';
      };
    };
}
