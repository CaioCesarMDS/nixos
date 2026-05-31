{ pkgs, config, ... }:

let
  colors = import ../shared/colors.nix;
  confirmTheme = import ../shared/confirm.nix {
    inherit pkgs colors;
  };

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
in
{
  home.packages = [ rofiClipboardManager ];
}
