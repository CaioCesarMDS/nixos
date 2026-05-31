{ pkgs, ... }:

let
  colors = import ../shared/colors.nix;
  confirmTheme = import ../shared/confirm.nix {
    inherit pkgs colors;
  };

  powermenuTheme = pkgs.writeText "rofi-powermenu.rasi" ''
    * {
      background: ${colors.background};
      background-alt: ${colors.background-alt};
      foreground: ${colors.foreground};
      foreground-muted: ${colors.foreground-muted};
      accent-primary: ${colors.accent-primary};
      accent-active: ${colors.accent-active};
      accent-urgent: ${colors.accent-urgent};
    }

    configuration {
      show-icons:             false;
      font:                   "JetBrainsMono Nerd Font 10";
    }

    window {
      width:                  46em;
      border-radius:          0.5em;
      transparency:           "real";
      location:               center;
      anchor:                 center;
      background-color:       transparent;
    }

    mainbox {
      spacing:                0;
      background-color:       @background;
      children:               [ "inputbar", "listview", "message" ];
    }

    inputbar {
      padding:                100px 80px;
      background-color:       transparent;
      background-image:       url("~/.cache/wallpaper/current", width);
      children:               [ "textbox-prompt-colon", "dummy", "prompt" ];
    }

    textbox-prompt-colon {
      str:                    " System";
      expand:                 false;
      padding:                12px;
      border-radius:          12px;
      background-color:       @background;
      text-color:             @foreground;
    }

    dummy {
      background-color:       transparent;
    }

    prompt {
      padding:                12px;
      border-radius:          12px;
      background-color:       @background;
      text-color:             @foreground;
    }

    listview {
      columns:                6;
      lines:                  1;
      cycle:                  true;
      dynamic:                true;
      scrollbar:              false;
      layout:                 vertical;
      fixed-height:           true;
      fixed-columns:          true;
      spacing:                15px;
      margin:                 15px;
      background-color:       transparent;
    }

    element {
      padding:                30px 10px;
      border-radius:          12px;
      background-color:       @background-alt;
      text-color:             @foreground;
    }

    element-text {
      font:                   "JetBrains Mono Nerd Font 32";
      background-color:       transparent;
      text-color:             inherit;
      vertical-align:         0.5;
      horizontal-align:       0.5;
    }

    element selected.normal {
      background-color:       @accent-active;
      text-color:             @foreground;
    }

    message {
      padding:                1em;
      background-color:       @background-alt;
      text-color:             @foreground;
    }

    textbox {
      background-color:       inherit;
      text-color:             inherit;
      vertical-align:         0.5;
      horizontal-align:       0.5;
    }
  '';

  rofiPowermenu = pkgs.writeShellApplication {
    name = "rofi-powermenu";
    runtimeInputs = with pkgs; [
      rofi
      util-linux
      procps
      gnugrep
      gawk
    ];
    text = ''
      get_system_info() {
        hostname_str=$(hostname)
        current_user=$(whoami)

        UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //' || true)
        if [ -z "$UPTIME" ]; then
          UPTIME=$(uptime | awk -F'up ' '{print $2}' | cut -d',' -f1 | xargs || echo "unknown")
        fi

        LAST_LOGIN=$(last -n 1 "$current_user" 2>/dev/null | grep -v "wtmp" | head -n 1 | awk '{print $4, $5, $6}' | xargs || true)

        if [ -z "$LAST_LOGIN" ]; then
          LAST_LOGIN=$(who -b | awk '{print $3, $4, $5}' | xargs || echo "Unknown")
        fi
      }

      set_icons() {
        declare -gA ACTIONS=(
          [""]="SHUTDOWN"
          [""]="REBOOT"
          ["󰍃"]="LOGOUT"
          ["󰌾"]="LOCK"
          ["󰏤"]="SUSPEND"
          ["󰤄"]="HIBERNATE"
        )
        ORDERED_ICONS=("" "" "󰍃" "󰌾" "󰏤" "󰤄")
        ICON_YES=''
        ICON_NO='󰅙'
      }

      confirm_action() {
        printf "%s\n%s\n" "$ICON_YES" "$ICON_NO" | \
          rofi -dmenu -p "Confirmation" \
            -mesg "Are you sure?" \
            -theme "${confirmTheme}"
      }

      show_menu() {
        local menu_items
        menu_items="$(printf "%s\n" "''${ORDERED_ICONS[@]}")"

        rofi -dmenu -p " $current_user@$hostname_str" \
          -mesg " Last Login: $LAST_LOGIN |  Uptime: $UPTIME" \
          -theme "${powermenuTheme}" <<<"$menu_items"
      }

      execute_action() {
        local selected_icon="$1"
        local action="''${ACTIONS[$selected_icon]:-}"

        [[ -z "$action" ]] && exit 1

        if [[ "$action" != "LOCK" ]]; then
          local confirmed
          confirmed="$(confirm_action)"
          [[ "''${confirmed// /}" != "''${ICON_YES// /}" ]] && return
        fi

        case "$action" in
          SHUTDOWN) systemctl poweroff ;;
          REBOOT) systemctl reboot ;;
          LOGOUT) hyprctl dispatch exit 0 ;;
          LOCK) hyprlock ;;
          SUSPEND) systemctl suspend ;;
          HIBERNATE) systemctl hibernate ;;
        esac
      }

      main() {
        get_system_info
        set_icons

        local selected_icon
        selected_icon="$(show_menu)"
        [[ -n "$selected_icon" ]] && execute_action "$selected_icon"
      }

      main "$@"
    '';
  };
in
{
  home.packages = [ rofiPowermenu ];
}
