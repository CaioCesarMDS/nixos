{ config, pkgs, ... }:

let
  colors = import ../shared/colors.nix;
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
  home.packages = [ rofiWallpaperManager ];
}
