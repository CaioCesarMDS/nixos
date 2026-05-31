{ pkgs, ... }:

let
  waybarHyprsunset = pkgs.writeShellApplication {
    name = "waybar-hyprsunset";
    runtimeInputs = with pkgs; [
      systemd
      util-linux
      procps
    ];
    text = ''
      if [[ "''${1:-}" != "-t" ]]; then
        if systemctl --user is-active --quiet hyprsunset; then
          printf "󰤄\n"
        else
          printf "\n"
        fi
        exit 0
      fi

      LOCKFILE="/tmp/hyprsunset.lock"
      exec 200>"$LOCKFILE"
      flock -n 200 || exit 1

      if systemctl --user is-active --quiet hyprsunset; then
        systemctl --user stop hyprsunset
      else
        systemctl --user start hyprsunset
      fi

      sleep 0.1
      pkill -RTMIN+1 waybar

      exit 0
    '';
  };
in
{
  home.packages = [ waybarHyprsunset ];
}
