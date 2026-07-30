{ ... }:
{
  den.aspects.swaync.homeManager =
    { pkgs, ... }:
    let
      hyprsunsetToggle = pkgs.writeShellApplication {
        name = "hyprsunset-toggle";
        text = ''
          STATE_DIR="$HOME/.local/state"
          STATE_FILE="$STATE_DIR/hyprsunset-enabled"

          mkdir -p "$STATE_DIR"

          if systemctl --user is-active --quiet hyprsunset.service; then
            systemctl --user stop hyprsunset.service
            echo 0 > "$STATE_FILE"
          else
            systemctl --user start hyprsunset.service
            echo 1 > "$STATE_FILE"
          fi
        '';
      };
    in
    {
      home.packages = [
        hyprsunsetToggle
        pkgs.libnotify
      ];

      services.swaync = {
        enable = true;
        settings = {
          positionX = "left";
          positionY = "top";
          layer = "overlay";
          cssPriority = "user";
          control-center-layer = "top";
          layer-shell = true;
          fit-to-screen = true;
          control-center-width = 450;
          control-center-margin-top = 8;
          control-center-margin-bottom = 8;
          control-center-margin-right = 0;
          control-center-margin-left = 8;
          notification-window-width = 350;
          notification-icon-size = 96;
          notification-body-image-width = 200;
          notification-body-image-height = 200;
          notification-2fa-action = true;
          notification-inline-replies = true;
          timeout-low = 3;
          timeout = 4;
          timeout-critical = 5;
          keyboard-shortcuts = true;
          image-visibility = "when-available";
          transition-time = 200;
          hide-on-clear = true;
          hide-on-action = true;
          script-fail-notify = true;
          widgets = [
            "mpris"
            "title"
            "dnd"
            "notifications"
            "buttons-grid"
          ];
          widget-config = {
            mpris = {
              show-album-art = "when-available";
              autohide = true;
            };
            title = {
              text = "Notifications";
              clear-all-button = true;
              button-text = "󰆴";
            };
            dnd = {
              text = "Do Not Disturb";
            };
            buttons-grid = {
              buttons-per-row = 4;
              actions = [
                {
                  label = "";
                  command = "hyprpicker -a -f hex -n";
                }
                {
                  label = "󰃟";
                  type = "toggle";
                  command = "hyprsunset-toggle";
                  update-command = ''
                    sh -c 'systemctl --user is-active --quiet hyprsunset.service && echo true || echo false'
                  '';
                }
                {
                  label = "";
                  command = "swaync-client -cp && hyprshot -m region -f $(date +%Y-%m-%d_%H-%M-%S).jpg -o ~/Pictures/Screenshots";
                }
                {
                  label = "";
                  command = "kitty btop";
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

          * {
            outline: none;
            box-shadow: none;
            color: @foreground;
            font-family: "JetBrainsMono Nerd Font Mono";
          }

          .control-center {
            background-color: @background;
            border-radius: 8px;
          }

          .control-center-list {
            background-color: transparent;
          }

          .control-center .notification-background .close-button,
          .notification-group-close-button {
            opacity: 0;
          }

          .notification-group {
            background-color: transparent;
          }

          .notification {
            background-color: @background;
            border-radius: 8px;
            padding: 6px;
          }

          .notification:hover {
            background-color: @background-alt;
          }

          .notification-content {
            margin-top: 4px;
            padding: 4px;
          }

          .summary {
            padding-top: 2px;
            font-size: 14px;
            font-weight: bold;
          }

          .time {
            padding-top: 2px;
            font-size: 14px;
            color: @foreground-muted;
          }

          .body {
            font-size: 13px;
            padding-top: 4px;
          }

          .notification image {
            margin-right: 12px;
            border-radius: 0;
          }

          .widget-mpris-title {
            font-size: 16px;
            font-weight: 700;
          }

          .widget-mpris-subtitle {
            font-size: 14px;
          }

          .widget-title {
            padding: 8px 8px 0 8px;
          }

          .widget-title > button {
            padding: 2px 16px;
            border-radius: 12px;
            font-size: 18px;
            background-color: #ea5e5e66;
            transition: all 0.4s ease-in-out;
          }

          .widget-title > button:hover {
            background-color: #f34c4c99;
            box-shadow: 0px 0px 5px red;
          }

          .widget-dnd {
            padding: 8px;
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

          .widget-buttons-grid {
            margin: 10px;
            padding: 0 8px 8px 8px;
            background-color: transparent;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button {
            background-color: transparent;
            border-radius: 12px;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.2), 0 0 8px rgba(0, 0, 0, 0.3);
          }

          .widget-buttons-grid > flowbox > flowboxchild > button:hover {
            background-color: @foreground;
            box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.2);
            transition: all 0.5s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button label {
            font-size: 24px;
            transition: all 0.7s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button:hover label {
            color: @background;
            transition: all 0.7s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
            background-color: @foreground;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked label {
            color: @background;
          }
        '';
      };
    };
}
