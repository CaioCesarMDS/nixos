{ config, pkgs, ... }:

let
  waybarColorpicker = pkgs.writeShellApplication {
    name = "waybar-colorpicker";
    runtimeInputs = with pkgs; [
      hyprpicker
      wl-clipboard
      libnotify
      coreutils
      gnugrep
      gawk
      procps
    ];
    text = ''
      LOC="${config.home.homeDirectory}/colorpicker"
      LIMIT=10

      mkdir -p "$LOC"
      touch "$LOC/colors"

      case "''${1:-}" in
        -l)
          cat "$LOC/colors"
          exit 0
          ;;

        -j)
          text="$(head -n 1 "$LOC/colors" || true)"
          if ! [[ "$text" =~ ^#[0-9a-fA-F]{6}$ ]]; then
            text="#ffffff"
          fi

          mapfile -t allcolors < <(tail -n +2 "$LOC/colors" | head -n 5)

          tooltip="<b>   HISTÓRICO</b>\n\n"
          tooltip+="-> <b>$text</b>  <span color='$text'></span>  \n"

          for i in "''${allcolors[@]}"; do
            if [[ "$i" =~ ^#[0-9a-fA-F]{6}$ ]]; then
              tooltip+="   <b>$i</b>  <span color='$i'></span>  \n"
            fi
          done

          tooltip="''${tooltip//$'\n'/\\n}"

          printf "{\"text\":\"<span color='%s'></span>\",\"tooltip\":\"%s\"}\n" "$text" "$tooltip"
          exit 0
          ;;
      esac

      pkill -x hyprpicker 2>/dev/null || true

      color="$(hyprpicker -a 2>/dev/null | grep -Eo '^#[0-9a-fA-F]{6}$' || true)"

      if [[ -z "$color" ]]; then
        exit 1
      fi

      printf "%s" "$color" | wl-copy

      prevColors="$(grep -vFx "$color" "$LOC/colors" 2>/dev/null | head -n $((LIMIT - 1)) || true)"
      { printf "%s\n" "$color"; printf "%s\n" "$prevColors"; } | sed '/^$/d' > "$LOC/colors"

      notify-send -u low -t 2000 "Color Picker" "Copied Color: $color"

      pkill -RTMIN+1 waybar
    '';
  };
in
{
  home.packages = [ waybarColorpicker ];
}
