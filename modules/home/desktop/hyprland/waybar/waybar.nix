{ ... }:

{
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
            "months" = "<span color='#ffead3'><b>{}</b></span>";
            "days" = "<span color='#ecc6d9'><b>{}</b></span>";
            "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
            "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
            "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
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
        "on-click" = "rfkill toggle bluetooth";
        "on-click-right" = "blueman-manager";
        "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
        "tooltip-format-connected" =
          "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}\n{device_address}";
        "tooltip-format-enumerate-connected-battery" =
          "{device_alias}\n{device_address}\n{device_battery_percentage}%";
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
      #tray,
      #mpris {
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

      #clock,
      #mpris {
        font-size: 0.9rem;
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
      #memory,
      #custom-bluefilter,
      #custom-power {
        padding-right: 1rem;
        border-bottom-right-radius: 8px;
        border-top-right-radius: 8px;
      }

      #cpu,
      #memory,
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

      #memory,
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
}
