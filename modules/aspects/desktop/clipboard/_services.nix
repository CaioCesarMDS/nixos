{ config, pkgs, ... }:
let
  cfg = config.clipboard;
in
{
  systemd.user.services.cliphist = {
    Unit = {
      Description = "cliphist - Clipboard manager";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist -max-items ${toString cfg.maxItems} store";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
