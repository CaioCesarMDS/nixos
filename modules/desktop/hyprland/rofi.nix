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

      clipboardManagerTheme = pkgs.writeText "rofi-clipboard-manager.rasi" ''
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
          readonly FAVORITES_FILE="${config.xdg.cacheHome}/clipboard/clipboard_favorites"
          ICON_YES=''
          ICON_NO='󰅙'

          DEL_MODE=false

          run_rofi() {
            rofi -dmenu -theme "${clipboardManagerTheme}"
          }

          process_selections() {
            if $DEL_MODE; then
              while IFS= read -r line; do
                [ -n "$line" ] && cliphist delete <<<"$line"
              done
            else
              while IFS= read -r line; do
                [ -n "$line" ] && echo -e "$line\t" | cliphist decode
              done | wl-copy
            fi
          }

          show_history() {
            mapfile -t items < <(cliphist list | sed '/^\s*$/d')
            [ ''${#items[@]} -eq 0 ] && return

            local list=()
            for i in "''${!items[@]}"; do
              list+=("$((i + 1)). ''${items[i]}")
            done

            selection=$(printf '%s\n' "''${list[@]}" | run_rofi) || return

            while IFS= read -r sel; do
              idx=$(awk -F'.' '{print $1}' <<<"$sel")
              if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le ''${#items[@]} ]; then
                echo "''${items[$((idx - 1))]}"
              fi
            done <<<"$selection" | process_selections
          }

          confirm_action() {
            printf "%s\n%s\n" "$ICON_YES" "$ICON_NO" | \
              rofi -dmenu -p "Confirmation" \
                -mesg "Are you sure?" \
                -theme "${confirmTheme}"
          }

          ensure_confirmation() {
            local confirmed
            confirmed="$(confirm_action)"
            [[ "''${confirmed// /}" != "''${ICON_YES// /}" ]] && return 1
            return 0
          }

          delete_items() {
            DEL_MODE=true
            show_history
          }

          clear_history() {
            ensure_confirmation || return
            cliphist wipe
          }

          fav_decode_array() {
            local -n _out=$1
            _out=()
            local line
            while IFS= read -r line; do
              _out+=("$(printf '%s' "$line" | base64 --decode | tr '\n' ' ')")
            done <"$FAVORITES_FILE"
          }

          pick_from_list() {
            local list=("$@")
            printf '%s\n' "''${list[@]}" | run_rofi
          }

          add_to_favorites() {
            mkdir -p "$(dirname "$FAVORITES_FILE")"

            mapfile -t items < <(cliphist list | sed '/^\s*$/d')
            [ ''${#items[@]} -eq 0 ] && {
              notify-send "Clipboard" "No items to favorite."
              return
            }

            selection=$(pick_from_list "''${items[@]}") || return

            id=$(cut -f1 <<<"$selection")

            decoded=$(printf '%s\t' "$id" | cliphist decode) || {
              notify-send "Clipboard" "Failed to decode cliphist id: $id"
              return
            }

            if [ -z "$decoded" ]; then
              notify-send "Clipboard" "Decoded content empty for id: $id"
              return
            fi

            encoded=$(printf "%s" "$decoded" | base64 -w0)
            if ! grep -Fxq "$encoded" "$FAVORITES_FILE" 2>/dev/null; then
              printf '%s\n' "$encoded" >>"$FAVORITES_FILE"
              notify-send "Clipboard" "Added to favorites"
            else
              notify-send "Clipboard" "Already a favorite"
            fi
          }

          view_favorites() {
            [ -s "$FAVORITES_FILE" ] || {
              notify-send "Clipboard" "No favorites."
              return
            }

            mapfile -t favs <"$FAVORITES_FILE"
            fav_decode_array decoded

            local list=()
            for i in "''${!decoded[@]}"; do
              list+=("$((i + 1)). ''${decoded[i]}")
            done

            selection=$(printf '%s\n' "''${list[@]}" | run_rofi) || return

            idx=$(awk -F'.' '{print $1}' <<<"$selection")

            if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le ''${#favs[@]} ]; then
              echo "''${favs[$((idx - 1))]}" | base64 --decode | wl-copy
              notify-send "Clipboard" "#$idx copied to clipboard"
            else
              notify-send "Clipboard" "Invalid selection"
            fi
          }

          delete_from_favorites() {
            [ -s "$FAVORITES_FILE" ] || {
              notify-send "Clipboard" "No favorites."
              return
            }

            mapfile -t favs <"$FAVORITES_FILE"
            fav_decode_array decoded

            local list=()
            for i in "''${!decoded[@]}"; do
              list+=("$((i + 1)). ''${decoded[i]}")
            done

            selection=$(printf '%s\n' "''${list[@]}" | run_rofi) || return
            idx=$(awk -F'.' '{print $1}' <<<"$selection")

            if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le ''${#favs[@]} ]; then
              sed -i "''${idx}d" "$FAVORITES_FILE"
              notify-send "Clipboard" "Removed #$idx from favorites"
            else
              notify-send "Clipboard" "Invalid selection"
            fi
          }

          clear_favorites() {
            ensure_confirmation || return
            : >"$FAVORITES_FILE"
          }

          manage_favorites() {
            local manage
            manage=$(printf '%s\n' "Add" "Delete" "Clear" | run_rofi) || return
            case "$manage" in
            Add) add_to_favorites ;;
            Delete) delete_from_favorites ;;
            Clear) clear_favorites ;;
            esac
          }

          main() {
            local action="''${1:-}"
            [ -z "$action" ] && action=$(printf '%s\n' "History" "Delete" "View Favorites" "Manage Favorites" "Clear History" | run_rofi)

            case "$action" in
            -c | --copy | "History") show_history ;;
            "Delete") delete_items ;;
            -f | --favorites | "View Favorites") view_favorites ;;
            "Manage Favorites") manage_favorites ;;
            -w | --wipe | "Clear History") clear_history ;;
            -h | --help | *) echo "Usage: $0 [ --copy | --favorites | --wipe | --help ]" ;;
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
          readonly WALLPAPERS_DIR="${config.home.homeDirectory}/Pictures/Wallpapers"
          readonly CACHE_DIR="${config.xdg.cacheHome}"
          readonly WALLPAPERS_CACHE_DIR="$CACHE_DIR/wallpaper"
          readonly THUMB_DIR="$WALLPAPERS_CACHE_DIR/thumbs"
          readonly CURRENT_WALLPAPER="$WALLPAPERS_CACHE_DIR/current"
          readonly LOCKSCREEN_WALLPAPER="$WALLPAPERS_CACHE_DIR/lockscreen"

          mkdir -p "$WALLPAPERS_CACHE_DIR" "$THUMB_DIR"

          ensure_symlink() {
            local target="$1" link="$2"
            mkdir -p "$(dirname "$link")"
            ln -sfn "$target" "$link"
          }

          mapfile -d "" -t WALLPAPER_LIST < <(
            find "$WALLPAPERS_DIR" -type f \
              \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
              -print0 | sort -z
          )

          if [ "''${#WALLPAPER_LIST[@]}" -eq 0 ]; then
            echo "No wallpapers found in directory: $WALLPAPERS_DIR" >&2
            exit 1
          fi

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

            case "$source_path" in
              *.gif|*.GIF)
                magick "''${source_path}[0]" -auto-orient -thumbnail "512x512^" -gravity center -extent "512x512" -strip "$thumbnail_path" 2>/dev/null || {
                  rm -f "$thumbnail_path"
                  return 1
                }
                ;;
              *)
                magick "$source_path" -auto-orient -thumbnail "512x512^" -gravity center -extent "512x512" -strip "$thumbnail_path" 2>/dev/null || {
                  rm -f "$thumbnail_path"
                  return 1
                }
                ;;
            esac

            return 0
          }

          prewarm_thumbnails() {
            local max_jobs=4 active_jobs=0
            local wallpaper_path thumbnail_path

            for wallpaper_path in "''${WALLPAPER_LIST[@]}"; do
              thumbnail_path=$(get_thumbnail_path "$wallpaper_path")
              [ -s "$thumbnail_path" ] && continue

              (
                ensure_thumbnail "$wallpaper_path" "$thumbnail_path" >/dev/null 2>&1 || true
              ) &

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

            case "$wallpaper_path" in
              *.gif|*.GIF)
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
                ;;
              *)
                lockscreen_source="$wallpaper_path"
                ;;
            esac

            ensure_symlink "$lockscreen_source" "$LOCKSCREEN_WALLPAPER"
          }

          set_wall() {
            local wallpaper_path="$1"
            local current_wallpaper

            [ -f "$wallpaper_path" ] || {
              echo "File not found: $wallpaper_path" >&2
              return 1
            }

            current_wallpaper=$(readlink -f "$CURRENT_WALLPAPER" 2>/dev/null || true)

            if [ "$current_wallpaper" != "$wallpaper_path" ]; then
              ensure_symlink "$wallpaper_path" "$CURRENT_WALLPAPER"
            fi

            create_lockscreen_wallpaper "$wallpaper_path"

            awww img "$wallpaper_path" --transition-type any --transition-fps 60 --transition-duration 0.5

            notify-send -a "wallpaper-manager" -i "$LOCKSCREEN_WALLPAPER" -u low \
              "Wallpaper changed" \
              "Wallpaper set to: $(basename "$wallpaper_path")"
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
            local index
            index=$(get_current_index)
            set_wall "''${WALLPAPER_LIST[$(((index + 1) % ''${#WALLPAPER_LIST[@]}))]}"
          }

          prev_wall() {
            local index
            index=$(get_current_index)
            set_wall "''${WALLPAPER_LIST[$(((index - 1 + ''${#WALLPAPER_LIST[@]}) % ''${#WALLPAPER_LIST[@]}))]}"
          }

          random_wall() {
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

          wallpaper_to_rofi_line() {
            local wallpaper_path="$1"
            local wallpaper_name wallpaper_thumb icon_path

            wallpaper_name=$(basename "$wallpaper_path")
            wallpaper_thumb=$(get_thumbnail_path "$wallpaper_path")

            if [ -s "$wallpaper_thumb" ]; then
              icon_path="$wallpaper_thumb"
            else
              icon_path=""
            fi

            printf '%s:::%s:::%s\0icon\x1f%s\n' "$wallpaper_name" "$wallpaper_path" "$wallpaper_thumb" "$icon_path"
          }

          get_rofi_style() {
            local columns=4

          cat <<EOF
          listview{columns:''${columns}; spacing:5em;}
          element{orientation:vertical; border-radius:20px;}
          element-icon{size:26em;border-radius:0px;}
          element-text{padding:1em;}
          EOF
          }

          generate_rofi_lines() {
            local rofi_input_file
            rofi_input_file=$(mktemp)

            for wallpaper in "''${WALLPAPER_LIST[@]}"; do
              wallpaper_to_rofi_line "$wallpaper"
            done > "$rofi_input_file"

            printf '%s\n' "$rofi_input_file"
          }

          select_wall() {
            [ "''${#WALLPAPER_LIST[@]}" -gt 0 ] || exit 1

            local rofi_input_file rofi_output selected_path rofi_style

            prewarm_thumbnails >/dev/null 2>&1 &

            rofi_input_file=$(generate_rofi_lines)
            rofi_style=$(get_rofi_style)

            cleanup_rofi_input_file() {
              [ -n "''${rofi_input_file:-}" ] && [ -f "$rofi_input_file" ] && rm -f "$rofi_input_file"
            }
            trap cleanup_rofi_input_file EXIT

            rofi_output=$(rofi -dmenu -show-icons \
              -display-column-separator ":::" -display-columns 1 \
              -theme-str "$rofi_style" -theme "${wallpaperManagerTheme}" <"$rofi_input_file")

            [ -n "$rofi_output" ] || return 1

            selected_path=$(awk -F ':::' '{print $2}' <<<"$rofi_output")

            if [ -n "$selected_path" ] && [ -f "$selected_path" ]; then
              set_wall "$selected_path"
              return 0
            fi

            echo "Selected file does not exist: $selected_path" >&2
            exit 1
          }

          main() {
            case "''${1-}" in
              -n|--next)   next_wall ;;
              -p|--prev)   prev_wall ;;
              -r|--random) random_wall ;;
              -s|--set)    set_wall "''${2:?Error: Please provide a wallpaper file path}" ;;
              -S|--select) select_wall ;;
              -c|--current) readlink -f "$CURRENT_WALLPAPER" ;;
              -h|--help|*) echo "Usage: $0 [ --next | --prev | --random | --set <wallpaper> | --select | --current ]" ;;
            esac
          }

          main "$@"
        '';
      };
    in
    {
      home.packages = [
        rofiPowermenu
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
