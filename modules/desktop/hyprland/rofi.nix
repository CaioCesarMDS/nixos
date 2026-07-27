{ ... }:
{
  den.aspects.rofi.homeManager =
    { config, pkgs, ... }:

    let
      # ===================================================
      #                       COLORS
      # ===================================================
      colors = {
        background = "#2A2A2A";
        background-alt = "#383838";
        foreground = "#CCCCCC";
        foreground-muted = "#A0A0A0";
        accent-primary = "#B392F0";
        accent-active = "#79B8FF";
        accent-urgent = "#FF7A84";
      };

      # ===================================================
      #                  ROFI THEMES
      # ===================================================
      confirmTheme = pkgs.writeText "rofi-confirm.rasi" ''
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
          modi:                       "drun";
          show-icons:                 false;
          font:                       "JetBrainsMono Nerd Font 10";
        }

        window {
          location:               center;
          anchor:                 center;
          fullscreen:             false;
          width:                  20em;
          border-radius:          0.5em;
        }

        mainbox {
          children:               [ "message", "listview" ];
          background-color:       @background;
        }

        message {
          str:                    "Are you sure?";
          padding:                1.5em;
          text-color:             @foreground;
          background-color:       @background-alt;
        }

        textbox {
          background-color:       inherit;
          text-color:             inherit;
          vertical-align:         0.5;
          horizontal-align:       0.5;
        }

        listview {
          background-color:       @background;
          columns:                2;
          lines:                  1;
          padding:                1em;
          spacing:                1em;
        }

        element-text {
          horizontal-align:       0.5;
        }

        textbox {
          horizontal-align:       0.5;
        }

        element {
          padding:                16px 8px;
          border-radius:          12px;
          background-color:       @background-alt;
          text-color:             @foreground;
        }

        element-text {
          font:                   "JetBrainsMono Nerd Font 32";
          background-color:       transparent;
          text-color:             inherit;
          vertical-align:         0.5;
          horizontal-align:       0.5;
        }

        element selected.normal {
          background-color:       @accent-active;
          text-color:             @background-alt;
        }
      '';

      passwordPromptTheme = pkgs.writeText "rofi-password.rasi" ''
        * {
          background:        ${colors.background};
          background-alt:    ${colors.background-alt};
          foreground:        ${colors.foreground};
          foreground-muted:  ${colors.foreground-muted};
          accent-primary:    ${colors.accent-primary};
          accent-active:     ${colors.accent-active};
          accent-urgent:     ${colors.accent-urgent};

          font: "JetBrainsMono Nerd Font 10";
        }

        configuration {
          show-icons: false;
        }

        window {
          width:             26em;
          transparency:      "real";
          border-radius:     0.5em;
          background-color:  @background;
        }

        mainbox {
          padding:           1em;
          background-color:  transparent;
          children:          [ "inputbar" ];
        }

        inputbar {
          padding:           0.5em;
          border-radius:     0.5em;
          background-color:  @background-alt;
          children:          [ "textbox-prompt-colon", "entry" ];
        }

        textbox-prompt-colon {
          str:               "󰌾";
          expand:            false;
          padding:           0.8em 0.5em;
          background-color:  transparent;
          text-color:        @foreground;
        }

        entry {
          expand:            true;
          padding:           0.8em;
          background-color:  transparent;
          text-color:        @foreground;
          placeholder:       "Password";
          placeholder-color: @foreground-muted;
        }
      '';

      powerMenuTheme = pkgs.writeText "rofi-power-menu.rasi" ''
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
          text-color:             @background-alt;
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

      launcherTheme = pkgs.writeText "rofi-launcher.rasi" ''
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
          modi:                   "drun,filebrowser,window,run";
          show-icons:             true;
          drun-display-format:    "{name}";
          display-drun:           " ";
          display-filebrowser:    " ";
          display-window:         " ";
          display-run:            " ";
          window-format:          "{w} · {c} · {t}";
          hover-select:           false;
          font:                   "JetBrainsMono Nerd Font 10";
          icon-theme:             "PapirusDark";
        }

        window {
          width:                  56em;
          height:                 35em;
          transparency:           "real";
          border-radius:          0.5em;
          background-color:       @background;
        }

        mainbox {
          orientation:            horizontal;
          background-color:       transparent;
          children:               [ "imagebox", "listbox" ];
        }

        imagebox {
          padding:                0 0 0.5em 0;
          orientation:            vertical;
          background-image:       url("~/.cache/wallpaper/current", height);
          children:               [ "inputbar", "dummy", "mode-switcher" ];
        }

        dummy {
          background-color:       transparent;
        }

        mode-switcher {
          orientation:            horizontal;
          width:                  6.6em;
          padding:                1.5em;
          spacing:                1.5em;
          background-color:       transparent;
        }

        button {
          padding:                15px;
          border-radius:          2em;
          background-color:       @background;
          text-color:             @foreground;
        }

        button selected {
          background-color:       @accent-active;
          text-color:             @background-alt;
        }

        inputbar {
          margin:                 1em;
          border-radius:          2em;
          background-color:       @background;
          children:               [ "textbox-prompt-colon", "entry" ];
        }

        textbox-prompt-colon {
          str:                    "";
          expand:                 false;
          background-color:       transparent;
          padding:                1em 0.3em 0 1em;
          text-color:             @foreground;
        }

        entry {
          padding:                1em;
          text-color:             @foreground;
          placeholder:            "Search";
          background-color:       transparent;
          placeholder-color:      inherit;
        }

        listbox {
          background-color:       @background;
          children:               [ "listview" ];
        }

        listview {
          padding:                1.5em;
          spacing:                0.5em;
          columns:                1;
          cycle:                  true;
          dynamic:                true;
          scrollbar:              false;
          fixed-height:           true;
          fixed-columns:          true;
          background-color:       transparent;
          text-color:             @foreground;
        }

        element {
          padding:                0.5em;
          background-color:       transparent;
          text-color:             @foreground;
          border-radius:          1.5em;
        }

        element selected.normal {
          text-color:             @background;
          background-color:       @accent-active;
        }

        element-icon {
          size:                   2.5em;
          background-color:       transparent;
          text-color:             inherit;
        }

        element-text {
          horizontal-align:       0.1;
          vertical-align:         0.5;
          background-color:       transparent;
          text-color:             inherit;
        }
      '';

      listMenuTheme = pkgs.writeText "rofi-list-menu.rasi" ''
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
          modi:                   "drun";
          show-icons:             false;
          font:                   "JetBrainsMono Nerd Font 10";
        }

        window {
          width:                  40em;
          height:                 32em;
          transparency:           "real";
          border-radius:          0.5em;
          background-color:       @background;
        }

        mainbox {
          orientation:            vertical;
          background-color:       transparent;
          children:               [ "imagebox", "listbox" ];
        }

        imagebox {
          padding:                1em;
          orientation:            vertical;
          background-image:       url("~/.cache/wallpaper/current", width);
          children:               [ "inputbar"];
        }

        inputbar {
          border-radius:          2em;
          background-color:       @background;
          children:               [ "textbox-prompt-colon", "entry" ];
        }

        textbox-prompt-colon {
          str:                    "";
          expand:                 false;
          padding:                1em 0.3em 0 1em;
          background-color:       transparent;
          text-color:             @foreground;
        }

        entry {
          padding:                1em;
          text-color:             @foreground;
          placeholder:            "Search";
          background-color:       transparent;
          placeholder-color:      inherit;
        }

        listbox {
          background-color:       @background;
          children:               [ "listview" ];
        }

        listview {
          padding:                1.5em;
          spacing:                0.5em;
          columns:                1;
          cycle:                  true;
          dynamic:                true;
          scrollbar:              false;
          fixed-height:           true;
          fixed-columns:          true;
          background-color:       transparent;
          text-color:             @foreground;
        }

        element {
          padding:                0.5em;
          background-color:       transparent;
          text-color:             @foreground;
          border-radius:          1em;
        }

        element selected.normal {
          background-color:       @accent-active;
          text-color:             @background-alt;
        }

        element-text {
          background-color:       transparent;
          text-color:             inherit;
        }
      '';

      wallpaperManagerTheme = pkgs.writeText "rofi-wallpaper-manager.rasi" ''
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
          modi:                        "drun";
          show-icons:                  true;
          drun-display-format:         "{name}";
          font:                        "JetBrainsMono Nerd Font 10";
        }

        window {
          width:                       80%;
          enabled:                     true;
          fullscreen:                  false;
          transparency:                "real";
          cursor:                      "default";
          spacing:                     0em;
          padding:                     0em;
          border:                      0em;
          border-radius:               30px 5px 30px 5px;
          border-color:                transparent;
          background-color:            @background;
        }

        mainbox {
          enabled:                     true;
          orientation:                 vertical;
          children:                    [ "listview" , "inputbar" ];
          background-color:            transparent;
        }

        listview {
          enabled:                     true;
          spacing:                     4em;
          padding:                     3em;
          lines:                       1;
          dynamic:                     false;
          fixed-height:                false;
          fixed-columns:               true;
          reverse:                     true;
          cursor:                      "default";
          background-color:            transparent;
          text-color:                  @foreground;
        }

        element {
          enabled:                     true;
          spacing:                     0em;
          padding:                     0em;
          cursor:                      pointer;
          background-color:            @background-alt;
          text-color:                  @foreground;
        }

        element selected.normal {
          background-color:            @accent-active;
          text-color:                  @background;
        }

        element-icon {
          cursor:                      inherit;
          size:                        10em;
          background-color:            @foreground;
          text-color:                  inherit;
          expand:                      false;
        }

        element-text {
          vertical-align:              0.5;
          horizontal-align:            0.5;
          cursor:                      inherit;
          background-color:            transparent;
          text-color:                  inherit;
        }

        inputbar {
          enabled:                     true;
          spacing:                     10px;
          padding:                     30px 60px;
          background-color:            transparent;
          text-color:                  @background;
          border-radius: 				       15px 5px 15px 5px;
          orientation:                 horizontal;
          children:                    [ "dummy", "textbox-prompt-colon", "entry", "entry-counter", "dummy" ];
        }

        dummy {
          expand:                      true;
          background-color:            transparent;
        }

        textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "󰸉 ";
          padding:                     10px 15px;
          border-radius:               15px 5px 15px 5px;
          background-color:            @background-alt;
          text-color:                  @foreground;
        }

        entry {
          enabled:                     true;
          expand:                      false;
          width:                       300px;
          padding:                     12px 16px;
          border-radius:               5px 15px 5px 15px;
          background-color:            @background-alt;
          text-color:                  @foreground;
          cursor:                      text;
          placeholder:                 "Search Wallpaper";
        }

        entry-counter {
          enabled: 					           true;
          expand:                      false;
        	orientation:				         horizontal;
          padding:                     12px 16px;
        	border-radius:               15px 5px 15px 5px;
          background-color:            @background-alt;
          text-color:                  @foreground;
        	children: 					         [ num-filtered-rows, textbox-divider, num-rows ];
        }

        #num-filtered-rows {
          background-color:            inherit;
        	enabled: 					           true;
        	text-color: 				         inherit;
        }

        #textbox-divider {
          background-color:            inherit;
        	enabled: 					           true;
        	text-color: 				         inherit;
        	str: 						             "/";
        }

        #num-rows {
          background-color:             inherit;
        	enabled: 					            true;
        	text-color: 			         	  inherit;
        }
      '';

      # ===================================================
      #                     SCRIPTS
      # ===================================================
      rofiPowermenu = pkgs.writeShellApplication {
        name = "rofi-power-menu";
        runtimeInputs = with pkgs; [
          rofi
          util-linux
          procps
          gnugrep
          gawk
        ];
        text = ''
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

          show_menu() {
            local menu_items
            menu_items="$(printf "%s\n" "''${ORDERED_ICONS[@]}")"

            rofi -dmenu -p " $current_user@$hostname_str" \
              -mesg " Last Login: $LAST_LOGIN |  Uptime: $UPTIME" \
              -theme "${powerMenuTheme}" <<<"$menu_items"
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
              LOGOUT) hyprctl eval 'hl.dispatch(hl.dsp.exit())' ;;
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

      rofiNetworkManager = pkgs.writeShellApplication {
        name = "rofi-network-manager";
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
            rofi -dmenu -password -theme "${passwordPromptTheme}" -p "$1"
          }

          show_menu() {
            rofi -dmenu -theme "${listMenuTheme}" -p "$1"
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
                -theme "${confirmTheme}")

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

      rofiLauncher = pkgs.writeShellApplication {
        name = "rofi-launcher";
        runtimeInputs = with pkgs; [
          rofi
        ];
        text = ''
          rofi -show drun -theme ${launcherTheme}
        '';
      };

      rofiClipboardManager = pkgs.writeShellApplication {
        name = "rofi-clipboard-manager";
        runtimeInputs = with pkgs; [
          rofi
          wl-clipboard
          cliphist
          util-linux
          procps
          gnugrep
          gawk
          libnotify
        ];
        text = ''
          set_constants() {
             readonly FAVORITES_FILE="${config.xdg.cacheHome}/clipboard/clipboard_favorites"
           }

           set_icons() {
             readonly ICON_HISTORY=" "
             readonly ICON_DEL="󰆴 "
             readonly ICON_FAV="󰓎 "
             readonly ICON_MANAGE="󰒓 "
             readonly ICON_CLEAR="󰃢 "
             readonly ICON_ADD="󰐕 "

             readonly ICON_YES=" "
             readonly ICON_NO="󰅙 "
             readonly ICON_BACK="󰌍 "
           }

           show_menu() {
             rofi -dmenu -theme "${listMenuTheme}" -p "$1"
           }

           notify_info() {
             notify-send "Clipboard Manager" "$1" -t "''${2:-3000}"
           }

           confirm_action() {
             local confirmed
             confirmed=$(printf "%s\n%s\n" "$ICON_YES" "$ICON_NO" | \
               rofi -dmenu -p "Confirmation" \
                 -mesg "Are you sure?" \
                 -theme "${confirmTheme}")

             [[ "''${confirmed// /}" == "''${ICON_YES// /}" ]]
           }

           fav_decode_array() {
             local -n _out=$1
             _out=()
             local line
             while IFS= read -r line; do
               _out+=("$(printf '%s' "$line" | base64 --decode | tr '\n' ' ')")
             done <"$FAVORITES_FILE"
           }

           menu_history() {
             local items
             mapfile -t items < <(cliphist list | sed '/^\s*$/d')
             local total=''${#items[@]}

             if [ "$total" -eq 0 ]; then
               notify_info "Clipboard history is empty."
               main_menu
               return
             fi

             local back_opt="''${ICON_BACK} Back"
             local list=("$back_opt")
             for i in "''${!items[@]}"; do
               local num=$((total - i))
               local snippet="''${items[i]#*$'\t'}"
               list+=("$num. $snippet")
             done

             local selection
             selection=$(printf '%s\n' "''${list[@]}" | show_menu "Copy History")

             [ -z "$selection" ] && return
             [[ "$selection" == "$back_opt" ]] && { main_menu; return; }

             while IFS= read -r sel; do
               local num
               num=$(awk -F'.' '{print $1}' <<<"$sel")
               if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$total" ]; then
                 local idx=$((total - num))
                 printf "%s\n" "''${items[$idx]}" | cliphist decode
               fi
             done <<<"$selection" | wl-copy

             notify_info "Copied to clipboard."
           }

           menu_delete_items() {
             local items
             mapfile -t items < <(cliphist list | sed '/^\s*$/d')
             local total=''${#items[@]}

             if [ "$total" -eq 0 ]; then
               notify_info "Clipboard history is empty."
               main_menu
               return
             fi

             local back_opt="''${ICON_BACK} Back"
             local list=("$back_opt")
             for i in "''${!items[@]}"; do
               local num=$((total - i))
               local snippet="''${items[i]#*$'\t'}"
               list+=("$num. $snippet")
             done

             local selection
             selection=$(printf '%s\n' "''${list[@]}" | show_menu "Delete Items")

             [ -z "$selection" ] && return
             [[ "$selection" == "$back_opt" ]] && { main_menu; return; }

             while IFS= read -r sel; do
               local num
               num=$(awk -F'.' '{print $1}' <<<"$sel")
               if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$total" ]; then
                 local idx=$((total - num))
                 cliphist delete <<<"''${items[$idx]}"
               fi
             done <<<"$selection"

             notify_info "Item(s) deleted."
             menu_delete_items
           }

           menu_clear_history() {
             if confirm_action; then
               cliphist wipe
               notify_info "Clipboard history cleared."
             fi
             main_menu
           }

           menu_view_favorites() {
             if [ ! -s "$FAVORITES_FILE" ]; then
               notify_info "No favorites saved."
               main_menu
               return
             fi

             local favs decoded
             mapfile -t favs <"$FAVORITES_FILE"
             fav_decode_array decoded
             local total=''${#decoded[@]}

             local back_opt="''${ICON_BACK} Back"
             local list=("$back_opt")

             for (( i=total-1; i>=0; i-- )); do
               local num=$((i + 1))
               list+=("$num. ''${decoded[i]}")
             done

             local selection
             selection=$(printf '%s\n' "''${list[@]}" | show_menu "Favorites")

             [ -z "$selection" ] && return
             [[ "$selection" == "$back_opt" ]] && { main_menu; return; }

             local num
             num=$(awk -F'.' '{print $1}' <<<"$selection")

             if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$total" ]; then
               local idx=$((num - 1))
               echo "''${favs[$idx]}" | base64 --decode | wl-copy
               notify_info "Favorite copied to clipboard."
             else
               notify_info "Invalid selection."
             fi
           }

           menu_add_favorite() {
             mkdir -p "$(dirname "$FAVORITES_FILE")"

             local items
             mapfile -t items < <(cliphist list | sed '/^\s*$/d')
             local total=''${#items[@]}

             if [ "$total" -eq 0 ]; then
               notify_info "No history items to favorite."
               manage_favorites_menu
               return
             fi

             local back_opt="''${ICON_BACK} Back"
             local list=("$back_opt")
             for i in "''${!items[@]}"; do
               local num=$((total - i))
               local snippet="''${items[i]#*$'\t'}"
               list+=("$num. $snippet")
             done

             local selection
             selection=$(printf '%s\n' "''${list[@]}" | show_menu "Add to Favorites")

             [ -z "$selection" ] && return
             [[ "$selection" == "$back_opt" ]] && { manage_favorites_menu; return; }

             local num
             num=$(awk -F'.' '{print $1}' <<<"$selection")

             if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$total" ]; then
               local idx=$((total - num))
               local orig_item="''${items[$idx]}"

               local decoded
               if ! decoded=$(printf '%s\n' "$orig_item" | cliphist decode); then
                 notify_info "Failed to decode history item."
                 manage_favorites_menu
                 return
               fi

               if [ -z "$decoded" ]; then
                 notify_info "Decoded content is empty."
                 manage_favorites_menu
                 return
               fi

               local encoded
               encoded=$(printf "%s" "$decoded" | base64 -w0)

               if ! grep -Fxq "$encoded" "$FAVORITES_FILE" 2>/dev/null; then
                 printf '%s\n' "$encoded" >>"$FAVORITES_FILE"
                 notify_info "Added to favorites."
               else
                 notify_info "Item is already a favorite."
               fi
             else
               notify_info "Invalid selection."
             fi

             manage_favorites_menu
           }

           menu_delete_favorite() {
             if [ ! -s "$FAVORITES_FILE" ]; then
               notify_info "No favorites to delete."
               manage_favorites_menu
               return
             fi

             local favs decoded
             mapfile -t favs <"$FAVORITES_FILE"
             fav_decode_array decoded
             local total=''${#decoded[@]}

             local back_opt="''${ICON_BACK} Back"
             local list=("$back_opt")

             for (( i=total-1; i>=0; i-- )); do
               local num=$((i + 1))
               list+=("$num. ''${decoded[i]}")
             done

             local selection
             selection=$(printf '%s\n' "''${list[@]}" | show_menu "Delete Favorite")

             [ -z "$selection" ] && return
             [[ "$selection" == "$back_opt" ]] && { manage_favorites_menu; return; }

             local num
             num=$(awk -F'.' '{print $1}' <<<"$selection")

             if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$total" ]; then
               sed -i "''${num}d" "$FAVORITES_FILE"
               notify_info "Removed favorite."
             else
               notify_info "Invalid selection."
             fi

             manage_favorites_menu
           }

           menu_clear_favorites() {
             if confirm_action; then
               : >"$FAVORITES_FILE"
               notify_info "Favorites cleared."
             fi
             manage_favorites_menu
           }

           manage_favorites_menu() {
             local options=(
               "''${ICON_ADD} Add from History"
               "''${ICON_DEL} Delete Favorite"
               "''${ICON_CLEAR} Clear Favorites"
               "''${ICON_BACK} Back"
             )

             local choice
             choice=$(printf "%s\n" "''${options[@]}" | show_menu "Manage Favorites")

             case "$choice" in
               "''${ICON_ADD}"*) menu_add_favorite ;;
               "''${ICON_DEL}"*) menu_delete_favorite ;;
               "''${ICON_CLEAR}"*) menu_clear_favorites ;;
               "''${ICON_BACK}"*) main_menu ;;
             esac
           }

           main_menu() {
             local options=(
               "''${ICON_HISTORY} Clipboard History"
               "''${ICON_FAV} View Favorites"
               "''${ICON_MANAGE} Manage Favorites"
               "''${ICON_DEL} Delete Items"
               "''${ICON_CLEAR} Clear History"
             )

             local choice
             choice=$(printf "%s\n" "''${options[@]}" | show_menu "Clipboard")

             case "$choice" in
               "''${ICON_HISTORY}"*) menu_history ;;
               "''${ICON_FAV}"*) menu_view_favorites ;;
               "''${ICON_MANAGE}"*) manage_favorites_menu ;;
               "''${ICON_DEL}"*) menu_delete_items ;;
               "''${ICON_CLEAR}"*) menu_clear_history ;;
             esac
           }

           main() {
             set_constants
             set_icons

             case "''${1:-}" in
               "")            main_menu ;;
               -H|--history)  menu_history ;;
               -f|--favorites) menu_view_favorites ;;
               -m|--manage)   manage_favorites_menu ;;
               -d|--delete)   menu_delete_items ;;
               -w|--wipe)     menu_clear_history ;;
               -h|--help)     echo "Usage: ''${0##*/} [ -H/--history | -f/--favorites | -m/--manage | -d/--delete | -w/--wipe | -h/--help ]" ;;
               *)             echo "Unknown option: $1" >&2; exit 1 ;;
             esac
           }

           main "$@"
        '';
      };

      rofiWallpaperManager = pkgs.writeShellApplication {
        name = "rofi-wallpaper-manager";
        runtimeInputs = with pkgs; [
          rofi
          awww
          libnotify
          imagemagick
          coreutils
          findutils
          gawk
        ];
        text = ''
          set_constants() {
            readonly WALLPAPERS_DIR="${config.home.homeDirectory}/Pictures/Wallpapers"
            readonly CACHE_DIR="${config.xdg.cacheHome}"
            readonly WALLPAPERS_CACHE_DIR="$CACHE_DIR/wallpaper"
            readonly THUMB_DIR="$WALLPAPERS_CACHE_DIR/thumbs"
            readonly CURRENT_WALLPAPER="$WALLPAPERS_CACHE_DIR/current"
            readonly LOCKSCREEN_WALLPAPER="$WALLPAPERS_CACHE_DIR/lockscreen"
          }

          setup() {
            mkdir -p "$WALLPAPERS_CACHE_DIR" "$THUMB_DIR"
          }

          notify_info() {
            local msg="$1"
            local sub_msg="''${2:-}"
            local icon="''${3:-}"

            if [ -n "$icon" ] && [ -f "$icon" ]; then
              notify-send -a "Wallpaper Manager" -i "$icon" -u low "$msg" "$sub_msg"
            else
              notify-send "Wallpaper Manager" "$msg" -t 3000
            fi
          }

          ensure_symlink() {
            local target="$1" link="$2"
            mkdir -p "$(dirname "$link")"
            ln -sfn "$target" "$link"
          }

          init_wallpapers() {
            mapfile -d "" -t WALLPAPER_LIST < <(
              find -L "$WALLPAPERS_DIR" -type f \
                \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
                -print0 | sort -z
            )

            if [ "''${#WALLPAPER_LIST[@]}" -eq 0 ]; then
              notify_info "No wallpapers found" "Directory: $WALLPAPERS_DIR"
              exit 1
            fi
          }

          get_thumbnail_key() {
            local wallpaper_path="$1"
            local wallpaper_mtime wallpaper_size
            wallpaper_mtime=$(stat -c '%Y' -- "$wallpaper_path")
            wallpaper_size=$(stat -c '%s' -- "$wallpaper_path")
            printf '%s|%s|%s' "$wallpaper_path" "$wallpaper_mtime" "$wallpaper_size" | sha256sum | awk '{print $1}'
          }

          get_thumbnail_path() {
            local wallpaper_path="$1"
            local wallpaper_key
            wallpaper_key=$(get_thumbnail_key "$wallpaper_path")
            printf '%s/%s.png' "$THUMB_DIR" "$wallpaper_key"
          }

          ensure_thumbnail() {
            local source_path="$1" thumbnail_path="$2"
            [ -s "$thumbnail_path" ] && return 0

            local target="''${source_path}"
            [[ "$source_path" =~ \.(gif|GIF)$ ]] && target="''${source_path}[0]"

            magick "$target" -auto-orient -thumbnail "512x512^" -gravity center -extent "512x512" -strip "$thumbnail_path" 2>/dev/null || {
              rm -f "$thumbnail_path"
              return 1
            }
            return 0
          }

          prewarm_thumbnails() {
            local max_jobs=4 active_jobs=0
            local wallpaper_path thumbnail_path

            for wallpaper_path in "''${WALLPAPER_LIST[@]}"; do
              thumbnail_path=$(get_thumbnail_path "$wallpaper_path")
              [ -s "$thumbnail_path" ] && continue

              ( ensure_thumbnail "$wallpaper_path" "$thumbnail_path" >/dev/null 2>&1 || true ) &

              active_jobs=$((active_jobs + 1))
              if [ "$active_jobs" -ge "$max_jobs" ]; then
                wait -n || true
                active_jobs=$((active_jobs - 1))
              fi
            done
          }

          create_lockscreen_wallpaper() {
            local wallpaper_path="$1"
            local lockscreen_source

            if [[ "$wallpaper_path" =~ \.(gif|GIF)$ ]]; then
              local wallpaper_key lockscreen_file
              wallpaper_key=$(get_thumbnail_key "$wallpaper_path")
              lockscreen_file="$WALLPAPERS_CACHE_DIR/lockscreen-$wallpaper_key.png"

              if [ ! -s "$lockscreen_file" ]; then
                magick "''${wallpaper_path}[0]" -auto-orient -strip "$lockscreen_file" 2>/dev/null || {
                  rm -f "$lockscreen_file"
                  echo "Failed to generate lockscreen wallpaper from GIF: $wallpaper_path" >&2
                  return 1
                }
              fi
              lockscreen_source="$lockscreen_file"
            else
              lockscreen_source="$wallpaper_path"
            fi

            ensure_symlink "$lockscreen_source" "$LOCKSCREEN_WALLPAPER"
          }

          set_wall() {
            local wallpaper_path="$1"
            local current_wallpaper

            if [ ! -f "$wallpaper_path" ]; then
              notify_info "Error" "File not found: $wallpaper_path"
              return 1
            fi

            current_wallpaper=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null || true)
            if [ "$current_wallpaper" != "$wallpaper_path" ]; then
              ensure_symlink "$wallpaper_path" "$CURRENT_WALLPAPER"
            fi

            create_lockscreen_wallpaper "$wallpaper_path"

            awww img "$wallpaper_path" --transition-type any --transition-fps 60 --transition-duration 0.5

            notify_info "Wallpaper changed" "Set to: $(basename "$wallpaper_path")" "$LOCKSCREEN_WALLPAPER"
          }

          get_current_index() {
            local current_wallpaper
            current_wallpaper=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null || true)

            for i in "''${!WALLPAPER_LIST[@]}"; do
              if [ "$(readlink -f "''${WALLPAPER_LIST[$i]}" 2>/dev/null || true)" = "$current_wallpaper" ]; then
                printf '%s\n' "$i"
                return 0
              fi
            done
            printf '0\n'
          }

          next_wall() {
            init_wallpapers
            local index
            index=$(get_current_index)
            set_wall "''${WALLPAPER_LIST[$(((index + 1) % ''${#WALLPAPER_LIST[@]}))]}"
          }

          prev_wall() {
            init_wallpapers
            local index
            index=$(get_current_index)
            set_wall "''${WALLPAPER_LIST[$(((index - 1 + ''${#WALLPAPER_LIST[@]}) % ''${#WALLPAPER_LIST[@]}))]}"
          }

          random_wall() {
            init_wallpapers
            local current_wallpaper next_wallpaper index
            current_wallpaper=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null || true)

            if [ "''${#WALLPAPER_LIST[@]}" -le 1 ]; then
              set_wall "''${WALLPAPER_LIST[0]}"
              return 0
            fi

            while :; do
              index=$((RANDOM % ''${#WALLPAPER_LIST[@]}))
              next_wallpaper="''${WALLPAPER_LIST[$index]}"
              [ "$next_wallpaper" != "$current_wallpaper" ] && break
            done

            set_wall "$next_wallpaper"
          }

          menu_select_wall() {
            init_wallpapers
            prewarm_thumbnails >/dev/null 2>&1 &

            local rofi_input_file
            rofi_input_file=$(mktemp)
            trap 'rm -f "$rofi_input_file"' EXIT

            for wallpaper in "''${WALLPAPER_LIST[@]}"; do
              local w_name w_thumb w_icon
              w_name=$(basename "$wallpaper")
              w_thumb=$(get_thumbnail_path "$wallpaper")
              [ -s "$w_thumb" ] && w_icon="$w_thumb" || w_icon=""

              printf '%s:::%s:::%s\0icon\x1f%s\n' "$w_name" "$wallpaper" "$w_thumb" "$w_icon"
            done > "$rofi_input_file"

            local columns=4
            local rofi_style="listview{columns:''${columns}; spacing:5em;} element{orientation:vertical; border-radius:20px;} element-icon{size:26em;border-radius:0px;} element-text{padding:1em;}"

            local rofi_output
            rofi_output=$(rofi -dmenu -show-icons \
              -display-column-separator ":::" -display-columns 1 \
              -theme-str "$rofi_style" \
              -theme "${wallpaperManagerTheme}" \
              -p "Wallpapers" <"$rofi_input_file")

            [ -z "$rofi_output" ] && return 1

            local selected_path
            selected_path=$(awk -F ':::' '{print $2}' <<<"$rofi_output")

            if [ -n "$selected_path" ] && [ -f "$selected_path" ]; then
              set_wall "$selected_path"
              return 0
            else
              notify_info "Error" "Selected file does not exist."
              exit 1
            fi
          }

          main() {
            set_constants
            setup

            case "''${1-}" in
              "")            menu_select_wall ;;
              -n|--next)     next_wall ;;
              -p|--prev)     prev_wall ;;
              -r|--random)   random_wall ;;
              -s|--set)      set_wall "''${2:?Error: Please provide a wallpaper file path}" ;;
              -c|--current)  readlink -f "$CURRENT_WALLPAPER" ;;
              -h|--help)     echo "Usage: ''${0##*/} [ -n/--next | -p/--prev | -r/--random | -s/--set <wallpaper> | -c/--current | -h/--help ]" ;;
              *)             echo "Unknown option: $1" >&2; exit 1 ;;
            esac
          }

          main "$@"
        '';
      };
    in
    {
      home.packages = [
        rofiPowermenu
        rofiNetworkManager
        rofiLauncher
        rofiClipboardManager
        rofiWallpaperManager
      ];

      programs.rofi = {
        enable = true;
      };

      xdg = {
        dataFile = {
          "applications/rofi.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Rofi
            Exec=true
            NoDisplay=true
          '';

          "applications/rofi-theme-selector.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Rofi Theme Selector
            Exec=true
            NoDisplay=true
          '';
        };
      };
    };
}
