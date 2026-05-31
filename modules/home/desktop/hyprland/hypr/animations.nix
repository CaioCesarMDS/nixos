{ lib, ... }:

let
  lua = lib.generators.mkLuaInline;
in
{
  wayland.windowManager.hyprland.settings = {
    curve = [
      {
        _args = [
          "smooth"
          { type = "bezier"; points = lua "{ {0.25, 0.1}, {0.25, 1.0} }"; }
        ];
      }
      {
        _args = [
          "balanced"
          { type = "bezier"; points = lua "{ {0.2, 0.0}, {0.3, 1.0} }"; }
        ];
      }
      {
        _args = [
          "crisp"
          { type = "bezier"; points = lua "{ {0.3, 0.0}, {0.4, 1.0} }"; }
        ];
      }
      {
        _args = [
          "flow"
          { type = "bezier"; points = lua "{ {0.15, 0.0}, {0.35, 1.0} }"; }
        ];
      }
    ];

    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 4;
        bezier = "smooth";
      }
      {
        leaf = "windowsIn";
        enabled = true;
        speed = 3;
        bezier = "balanced";
        style = "slide";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 2;
        bezier = "crisp";
        style = "slide";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 4;
        bezier = "flow";
        style = "slide";
      }
    ];
  };
}
