{ ... }:
{
  den.aspects.swaync.homeManager =
    { ... }:
    {
      services.swaync = {
        enable = true;
        settings = {
          # --- GENERAL SETTINGS ---
          positionX = "left";
          positionY = "top";
          layer = "overlay";
          control-center-layer = "top";
          layer-shell = true;
          cssPriority = "user";
          control-center-width = 450;
          control-center-margin-top = 8;
          control-center-margin-bottom = 8;
          control-center-margin-right = 0;
          control-center-margin-left = 8;
          notification-2fa-action = true;
          notification-inline-replies = true;
          notification-window-width = 350;
          notification-body-image-height = 180;
          notification-body-image-width = 200;
          timeout = 5;
          timeout-low = 3;
          timeout-critical = 1;
          fit-to-screen = true;
          keyboard-shortcuts = true;
          image-visibility = "when-available";
          transition-time = 200;
          hide-on-clear = true;
          hide-on-action = true;
          script-fail-notify = true;
          # --- WIDGET SETTINGS ---
          widgets = [
            "mpris"
            "title"
            "dnd"
            "notifications"
            "volume"
            "backlight"
            "buttons-grid"
          ];
          widget-config = {
            mpris = {
              show-album-art = "when-available";
            };
            title = {
              text = "Notifications";
              clear-all-button = true;
              button-text = "󰆴";
            };
            dnd = {
              text = "Do Not Disturb";
            };
            volume = {
              label = "󰕾";
            };
            backlight = {
              label = "󰃟";
              device = "amdgpu_bl1";
            };
            buttons-grid = {
              buttons-per-row = 4;
              actions = [
                {
                  label = "󰝟";
                  command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                  type = "toggle";
                }
                {
                  label = "󰍭";
                  command = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                  type = "toggle";
                }
                {
                  label = "";
                  command = "swaync-client -cp && hyprshot -m region -f $(date +%Y-%m-%d_%H-%M-%S).jpg -o ~/Pictures/screenshots";
                }
                {
                  label = "";
                  command = "kitty bash -i -c btop";
                }
              ];
            };
          };
        };

        style = ''
          @define-color background #2A2A2A;
          @define-color background-alt #383838;
          @define-color foreground #CCCCCC;
          @define-color foreground-muted #A0A0A0;
          @define-color accent-primary #B392F0;
          @define-color accent-active  #79B8FF;
          @define-color accent-urgent  #FF7A84;

          :root {
            --notification-icon-size: 50px;
          }

          * {
            outline: none;
            text-shadow: none;
            color: @foreground;
            font-family: "JetBrainsMono Nerd Font Mono";
          }

          /* Control Center */

          .control-center {
            background-color: @background;
            border-radius: 10px;
            box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.65);
          }

          .control-center-list {
            background-color: transparent;
          }

          /* Notification */

          .notification-group {
            background-color: transparent;
          }

          .notification-row {
            margin: 0;
            padding: 0;
          }

          .notification {
            background-color: @background;
            border-radius: 10px;
            padding: 0.5rem;
          }

          .notification-content {
            padding: 0.5rem 0 0.5rem 0;
          }

          .image {
            border-radius: 10px;
            margin-right: 0.5rem;
            min-width: 60px;
            min-height: 60px;
          }

          .summary {
            font-size: 1.05rem;
            font-weight: 600;
          }

          .body {
            padding-top: 0.6rem;
            font-size: 0.9rem;
            font-weight: 400;
            background-color: transparent;
          }

          .time {
            font-size: 1.05rem;
            font-weight: 600;
            margin-right: 0.3rem;
          }

          .close-button {
            background-color: #40404c;
            border-radius: 100%;
            min-width: 0.5rem;
            min-height: 0.5rem;
            margin: 0.2rem 0 0 0;
            padding: 0;
          }

          .close-button:hover {
            background-color: #f22424;
            transition: all 0.15s ease-in-out;
          }

          /* MPRIS Widget */

          .widget-mpris {
            padding: 0;
            border-radius: 10px;
            margin: 0;
          }

          .widget-mpris-title {
            font-weight: 700;
            font-size: 1.1rem;
          }

          .widget-mpris-subtitle {
            font-size: 0.9rem;
          }

          /* Notification title and clear button */

          .widget-title {
            padding: 0.8rem 0.8rem 0 0.8rem;
            font-weight: 700;
          }

          .widget-title > button {
            font-size: 1.2rem;
            background-color: #ea5e5e66;
            border-radius: 12px;
            padding: 0.1rem 1.08rem;
            transition: all 0.4s ease-in-out;
          }

          .widget-title > button:hover {
            background-color: #f34c4c99;
            box-shadow: 0px 0px 5px red;
          }

          /* Do Not Disturb Widget */

          .widget-dnd {
            min-height: 50px;
            padding: 0.8rem;
            color: @foreground;
          }

          .widget-dnd > switch {
            border-radius: 12px;
            background-color: @foreground-muted;
          }

          .widget-dnd > switch:checked {
            background-color: @foreground;
          }

          .widget-dnd > switch slider {
            background-color: @background;
            border-radius: 10px;
          }

          .widget-dnd > switch:checked slider {
            background-color: #272727;
            border-radius: 10px;
          }

          /* Slider */

          trough {
            background-color: transparent;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.2), 0 0 8px rgba(0, 0, 0, 0.3);
          }

          trough highlight {
            padding: 0.5rem;
            background-color: @foreground;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.5);
          }

          trough slider {
            all: unset;
          }

          /* Volume and Backligth Widgets */

          .widget-volume label,
          .widget-backlight label {
            font-size: 1.5rem;
          }

          /* Buttons Widget */

          .widget-buttons-grid {
            padding: 0 0.5rem 0.5rem 0.5rem;
            margin: 0.6rem;
            background-color: transparent;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button {
            background-color: transparent;
            border-radius: 12px;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.2), 0 0 8px rgba(0, 0, 0, 0.3);
          }

          .widget-buttons-grid > flowbox > flowboxchild > button:hover {
            background-color: @accent-active;
            box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.2);
            transition: all 0.5s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button label {
            font-size: 1.6rem;
            color: @foreground;
            transition: all 0.7s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button:hover label {
            color: black;
            transition: all 0.7s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
            background-color: @foreground;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked label {
            color: black;
          }
        '';
      };
    };
}
