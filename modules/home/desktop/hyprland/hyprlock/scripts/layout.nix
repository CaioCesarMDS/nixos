{ pkgs, ... }:

let
  hyprlockLayout = pkgs.writeShellApplication {
    name = "hyprlock-layout";
    runtimeInputs = with pkgs; [
      coreutils
      jq
    ];
    text = ''
      output=""

      check_layout() {
        data=$(hyprctl devices -j 2>/dev/null)

        layout=$(echo "$data" | jq -r '.keyboards[] | select(.main==true) | .layout')
        variant=$(echo "$data" | jq -r '.keyboards[] | select(.main==true) | .variant')

        layout=$(echo "$layout" | tr '[:lower:]' '[:upper:]')
        variant=$(echo "$variant" | tr '[:lower:]' '[:upper:]')

        if [[ -n "$layout" && "$layout" != "null" ]]; then
          output+="$layout"

          if [[ -n "$variant" && "$variant" != "null" ]]; then
            output+="/$variant"
          fi
        else
          output+="UNK"
        fi
      }

      check_layout
      echo "$output"
    '';
  };
in
{
  home.packages = [ hyprlockLayout ];
}
