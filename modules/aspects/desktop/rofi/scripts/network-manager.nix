{ ... }:
{
  den.aspects.network-manager.homeManager =
    {
      config,
      pkgs,
      ui,
      ...
    }:

    let
      themes = import ../themes/_default.nix { inherit config pkgs ui; };

      networkManager = pkgs.writeShellApplication {
        name = "network-manager";
        runtimeInputs = with pkgs; [
          rofi
          networkmanager
          libnotify
          gnugrep
          gawk
          coreutils
          gnused
        ];
        text = ''
          set_constants() {
            readonly LOG_FILE="/tmp/rofi-network-manager.log"
          }

          set_icons() {
            readonly ICON_WIFI=" "
            readonly ICON_ETH="󰈀 "
            readonly ICON_SAVED=" "
            readonly ICON_ACTIVE="󱘖 "
            readonly ICON_VPN="󰖂 "
            readonly ICON_BT="󰂯 "
            readonly ICON_TOGGLE="󰐌 "
            readonly ICON_DELETE="󰆴 "
            readonly ICON_EDITOR="󰒓 "

            readonly ICON_YES=" "
            readonly ICON_NO="󰅙 "
            readonly ICON_BACK="󰌍 "
          }

          show_password_prompt() {
            rofi -dmenu -password -theme "${themes.passwordTheme}" -p "$1"
          }

          show_menu() {
            rofi -dmenu -theme "${themes.listMenuTheme}" -p "$1"
          }

          notify_info() {
            notify-send "Network Manager" "$1" -t "''${2:-3000}"
          }

          execute_and_notify() {
            local ok_msg="$1"
            local err_msg="$2"
            shift 2

            {
              printf '\n[%s] Running:' "$(date '+%F %T')"
              printf ' %q' "$@"
              printf '\n'
            } >>"$LOG_FILE"

            if "$@" >>"$LOG_FILE" 2>&1; then
              notify_info "$ok_msg"
            else
              notify_info "$err_msg"
            fi
          }

          confirm_action() {
            local confirmed
            confirmed=$(printf "%s\n%s\n" "$ICON_YES" "$ICON_NO" | \
              rofi -dmenu -p "Confirmation" \
                -mesg "Are you sure?" \
                -theme "${themes.confirmTheme}")

            [[ "''${confirmed// /}" == "''${ICON_YES// /}" ]]
          }

          connect_saved() {
            local name="$1"
            notify_info "Connecting to $name..." 2000
            execute_and_notify "Successfully connected to $name" "Failed to connect to $name" nmcli connection up id "$name"
          }

          show_available_wifi() {
            notify_info "Scanning for Wi-Fi networks..." 2000
            nmcli device wifi rescan >/dev/null 2>&1 || true

            local raw_list
            raw_list=$(nmcli -t -f SSID,SECURITY,SIGNAL device wifi list | awk -F':' '
              $1 != "" {
                printf "%-25s | Signal: %3s%% | %s\n", $1, $3, $2
              }
            ' | sort -u)

            if [ -z "$raw_list" ]; then
              notify_info "No Wi-Fi networks found in range."
              wifi_menu
              return
            fi

            local back_opt="''${ICON_BACK} Back"
            local choice
            choice=$(echo -e "$back_opt\n$raw_list" | show_menu "Available Wi-Fi")

            [ -z "$choice" ] && return
            [[ "$choice" == "$back_opt" ]] && { wifi_menu; return; }

            local ssid
            ssid=$(echo "$choice" | awk -F' \\| ' '{print $1}' | sed 's/ *$//')
            [ -z "$ssid" ] && return

            if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
              connect_saved "$ssid"
            else
              local password
              if ! password=$(show_password_prompt "Password for $ssid (Leave blank if open)"); then
                return
              fi
              notify_info "Connecting to $ssid..."
              if [ -z "$password" ]; then
                execute_and_notify "Connected to $ssid" "Failed to connect to $ssid" nmcli device wifi connect "$ssid"
              else
                execute_and_notify "Connected to $ssid" "Failed to connect to $ssid (Wrong password?)" nmcli device wifi connect "$ssid" password "$password"
              fi
            fi
          }

          show_saved_wifi() {
            local saved_list
            saved_list=$(nmcli -t -f NAME,TYPE connection show | awk -F':' '$2 ~ /^(802-11-wireless|802-3-ethernet)$/ {print $1}')

            if [ -z "$saved_list" ]; then
              notify_info "No saved Wi-Fi or Ethernet connections found."
              wifi_menu
              return
            fi

            local back_opt="''${ICON_BACK} Back"
            local choice
            choice=$(echo -e "$back_opt\n$saved_list" | show_menu "Saved Connections")

            [ -z "$choice" ] && return
            [[ "$choice" == "$back_opt" ]] && { wifi_menu; return; }

            connect_saved "$choice"
          }

          wifi_menu() {
            local options=(
              "''${ICON_WIFI} Available Wi-Fi"
              "''${ICON_SAVED} Saved Networks"
              "''${ICON_BACK} Back"
            )

            local choice
            choice=$(printf "%s\n" "''${options[@]}" | show_menu "Wi-Fi Menu")

            case "$choice" in
              "''${ICON_WIFI}"*) show_available_wifi ;;
              "''${ICON_SAVED}"*) show_saved_wifi ;;
              "''${ICON_BACK}"*) main_menu ;;
            esac
          }

          show_vpn() {
            local vpn_list
            vpn_list=$(nmcli -t -f NAME,TYPE connection show | awk -F':' '$2 ~ /^(vpn|wireguard)$/ {print $1}')

            if [ -z "$vpn_list" ]; then
              notify_info "No VPN or WireGuard connections configured."
              main_menu
              return
            fi

            local back_opt="''${ICON_BACK} Back"
            local choice
            choice=$(echo -e "$back_opt\n$vpn_list" | show_menu "VPN / WireGuard")

            [ -z "$choice" ] && return
            [[ "$choice" == "$back_opt" ]] && { main_menu; return; }

            connect_saved "$choice"
          }

          show_bluetooth() {
            local bt_list
            bt_list=$(nmcli -t -f NAME,TYPE connection show | awk -F':' '$2=="bluetooth" {print $1}')

            if [ -z "$bt_list" ]; then
              notify_info "No paired Bluetooth network connections found."
              main_menu
              return
            fi

            local back_opt="''${ICON_BACK} Back"
            local choice
            choice=$(echo -e "$back_opt\n$bt_list" | show_menu "Bluetooth")

            [ -z "$choice" ] && return
            [[ "$choice" == "$back_opt" ]] && { main_menu; return; }

            connect_saved "$choice"
          }

          show_active() {
            local active_list
            active_list=$(nmcli -t -f NAME,DEVICE connection show --active | grep -v "^lo:" | awk -F':' '{print $1 " (" $2 ")"}')

            if [ -z "$active_list" ]; then
              notify_info "No active connections to disconnect."
              main_menu
              return
            fi

            local back_opt="''${ICON_BACK} Back"
            local choice
            choice=$(echo -e "$back_opt\n$active_list" | show_menu "Active Connections (Disconnect)")

            [ -z "$choice" ] && return
            [[ "$choice" == "$back_opt" ]] && { main_menu; return; }

            local name
            name=$(printf '%s\n' "$choice" | sed 's/ (.*)//')

            if confirm_action; then
              nmcli connection down id "$name" >>"$LOG_FILE" 2>&1
              notify_info "Disconnected from $name"
            fi
          }

          toggle_menu() {
            local wifi_state net_state bt_state
            wifi_state=$(nmcli radio wifi)
            net_state=$(nmcli networking)
            bt_state=$(rfkill list bluetooth | grep -q "Soft blocked: yes" && echo "disabled" || echo "enabled")

            local options=(
              "''${ICON_WIFI} Wi-Fi: $wifi_state"
              "''${ICON_BT} Bluetooth: $bt_state"
              "''${ICON_ETH} Networking: $net_state"
              "''${ICON_BACK} Back"
            )

            local choice
            choice=$(printf "%s\n" "''${options[@]}" | show_menu "Toggle Radios")

            case "$choice" in
              "Wi-Fi:"*)
                if [ "$wifi_state" = "enabled" ]; then
                  execute_and_notify "Wi-Fi disabled" "Failed to disable Wi-Fi" \
                    nmcli radio wifi off
                else
                  execute_and_notify "Wi-Fi enabled" "Failed to enable Wi-Fi" \
                    nmcli radio wifi on
                fi
                ;;
              "Bluetooth:"*)
                if [ "$bt_state" = "enabled" ]; then
                  execute_and_notify "Bluetooth disabled" "Failed to disable Bluetooth" \
                    rfkill block bluetooth
                else
                  execute_and_notify "Bluetooth enabled" "Failed to enable Bluetooth" \
                    rfkill unblock bluetooth
                fi
                ;;
              "Networking:"*)
                if [ "$net_state" = "enabled" ]; then
                  execute_and_notify "Networking disabled" "Failed to disable Networking" \
                    nmcli networking off
                else
                  execute_and_notify "Networking enabled" "Failed to enable Networking" \
                    nmcli networking on
                fi
                ;;
              "''${ICON_BACK}"*)
                main_menu
                ;;
            esac
          }

          delete_connection() {
            local target_list
            target_list=$(nmcli -t -f NAME connection show)

            if [ -z "$target_list" ]; then
              notify_info "No connections found to delete."
              main_menu
              return
            fi

            local back_opt="''${ICON_BACK} Back"
            local target
            target=$(echo -e "$back_opt\n$target_list" | show_menu "Delete Connection")

            [ -z "$target" ] && return
            [[ "$target" == "$back_opt" ]] && { main_menu; return; }

            if confirm_action; then
              execute_and_notify "Connection '$target' deleted" "Failed to delete '$target'" nmcli connection delete id "$target"
            fi
          }

          launch_editor() {
            notify_info "Opening Advanced GUI Editor..."
            nm-connection-editor >/dev/null 2>&1 &
            disown
          }

          main_menu() {
            local options=(
              "''${ICON_WIFI} Wi-Fi Menu"
              "''${ICON_VPN} VPN / WireGuard"
              "''${ICON_BT} Bluetooth"
              "''${ICON_ACTIVE} Active Connections (Disconnect)"
              "''${ICON_TOGGLE} Toggle Radios"
              "''${ICON_DELETE} Delete Connection"
              "''${ICON_EDITOR} Advanced GUI Editor"
            )

            local choice
            choice=$(printf "%s\n" "''${options[@]}" | show_menu "Network")

            case "$choice" in
              "''${ICON_WIFI}"*) wifi_menu ;;
              "''${ICON_VPN}"*) show_vpn ;;
              "''${ICON_BT}"*) show_bluetooth ;;
              "''${ICON_ACTIVE}"*) show_active ;;
              "''${ICON_TOGGLE}"*) toggle_menu ;;
              "''${ICON_DELETE}"*) delete_connection ;;
              "''${ICON_EDITOR}"*) launch_editor ;;
            esac
          }

          main() {
            set_constants
            set_icons

            case "''${1-}" in
              "")            main_menu ;;
              -w|--wifi)     wifi_menu ;;
              -h|--help)     echo "Usage: ''${0##*/} [ -w/--wifi | -h/--help]";;
              *)             echo "Unknown option: $1" >&2; exit 1 ;;
            esac
          }

          main "$@"
        '';
      };
    in
    {
      home.packages = [
        networkManager
      ];
    };
}
