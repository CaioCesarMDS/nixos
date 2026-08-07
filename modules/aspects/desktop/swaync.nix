{ ... }:
{
  den.aspects.swaync.homeManager =
    {
      config,
      pkgs,
      ui,
      ...
    }:
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
                  command = "swaync-client -cp && sleep 0.6 && hyprpicker -a -f hex -n";
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
          @define-color bg        alpha(${ui.colors.bg}, ${toString ui.opacity.popups});
          @define-color surface   alpha(${ui.colors.surface}, ${toString ui.opacity.popups});
          @define-color fg        ${ui.colors.fg};
          @define-color muted     ${ui.colors.muted};
          @define-color cyan      ${ui.colors.cyan};
          @define-color blue      ${ui.colors.blue};
          @define-color green     ${ui.colors.green};
          @define-color magenta   ${ui.colors.magenta};
          @define-color orange    ${ui.colors.orange};
          @define-color purple   ${ui.colors.purple};
          @define-color red       ${ui.colors.red};
          @define-color yellow    ${ui.colors.yellow};

          * {
            outline: none;
            box-shadow: none;
            color: @fg;
            font-size: 1rem;
            font-family: '${ui.font.propo}';
          }

          .control-center {
            background-color: @bg;
            border-radius: ${toString ui.border.radius}px;
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
            padding: 6px;
            background-color: @bg;
            border-radius: ${toString ui.border.radius}px;
          }

          .notification * {
            background-color: transparent;
          }
          .right * {
            opacity: 0;
          }

          .notification-content {
            margin-top: 4px;
            padding: 4px;
          }

          .summary {
            padding-top: 2px;
            font-weight: bold;
          }

          .time {
            padding-top: 2px;
            color: @muted;
          }

          .body {
            padding-top: 4px;
            font-size: 0.9rem;
          }

          .notification image {
            margin-right: 12px;
            border-radius: 0;
          }

          .widget-mpris-title {
            font-size: 1.1rem;
            font-weight: 700;
          }

          .widget-title > button {
            padding: 2px 16px;
            border-radius: 12px;
            background-color: alpha(@red, 0.5);
            transition: all 0.4s ease-in-out;
          }

          .widget-title > button:hover {
            background-color: @red;
            box-shadow: 0px 0px 5px red;
          }

          .widget-title > * ,
          .widget-title > button > * {
            font-size: 1.2rem;
          }

          .widget-dnd > * {
            font-size: 1.2rem;
          }

          .widget-dnd > switch {
            border-radius: 12px;
            background-color: alpha(@muted, 0.5);
          }

          .widget-dnd > switch:checked {
            background-color: @fg;
          }

          .widget-dnd > switch slider {
            background-color: @bg;
            border-radius: 10px;
          }

          .widget-dnd > switch:checked slider {
            background-color: @surface;
            border-radius: 10px;
          }

          .widget-buttons-grid {
            margin: 10px;
            background-color: transparent;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button {
            padding: 10px 8px;
            background-color: transparent;
            border-radius: ${toString ui.border.radius}px;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.2), 0 0 8px rgba(0, 0, 0, 0.3);
          }

          .widget-buttons-grid > flowbox > flowboxchild > button:hover {
            background-color: @blue;
            box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.2);
            transition: all 0.5s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button label {
            font-size: 1.2rem;
            transition: all 0.7s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button:hover label {
            color: @bg;
            transition: all 0.7s ease;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
            background-color: @blue;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked label {
            color: @bg;
          }
        '';
      };
    };
}
