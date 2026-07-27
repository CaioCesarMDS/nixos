{ ... }:
{
  den.aspects.hyprsunset.homeManager =
    { pkgs, ... }:
    let
      hyprsunsetRestore = pkgs.writeShellApplication {
        name = "hyprsunset-restore";
        text = ''
          STATE_FILE="$HOME/.local/state/hyprsunset-enabled"
          if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "1" ]; then
            systemctl --user start hyprsunset.service
          fi
        '';
      };
    in
    {
      home.packages = [
        hyprsunsetRestore
        pkgs.hyprsunset
      ];

      systemd.user.services = {
        hyprsunset = {
          Unit = {
            Description = "hyprsunset - Blue-light Filter";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 4800";
            Restart = "on-failure";
          };
        };

        hyprsunset-restore = {
          Unit = {
            Description = "Restores the hyprsunset state from the previous session";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${hyprsunsetRestore}/bin/hyprsunset-restore";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
