{ lib, pkgs, ... }:

let
  lua = lib.generators.mkLuaInline;
in
{
  systemd.user.services = {
    awww-daemon = {
      Unit = {
        Description = "awww daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    cliphist = {
      Unit = {
        Description = "Clipboard manager (cliphist)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    hyprsunset = {
      Unit = {
        Description = "Hyprsunset";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 4800";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    waybar = {
      Unit = {
        Description = "Waybar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    on = {
      _args = [
        "hyprland.start"
        (lua ''
          function()
            hl.exec_cmd("systemctl --user start graphical-session.target")
            hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 20")
          end'')
      ];
    };
  };
}
