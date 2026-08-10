{ config, lib, ... }:

let
  f = config.stylix.fonts;
  c = config.lib.stylix.colors.withHashtag;

  baseColors = {
    bg = c.base00;
    surface = c.base01;
    fg = c.base05;
    muted = c.base04;

    cyan = c.base0C;
    blue = c.base0D;
    green = c.base0B;
    magenta = c.base0F;
    orange = c.base09;
    purple = c.base0E;
    red = c.base08;
    yellow = c.base0A;
  };

  currentAccent = baseColors.blue;

  toHex =
    opacity:
    let
      intVal = builtins.floor (opacity * 255);
      hexDigits = [
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "A"
        "B"
        "C"
        "D"
        "E"
        "F"
      ];
      hiVal = intVal / 16;
      loVal = intVal - (hiVal * 16);

      hi = builtins.elemAt hexDigits hiVal;
      lo = builtins.elemAt hexDigits loVal;
    in
    "${hi}${lo}";

  withAlpha =
    color: opacity:
    let
      cleanColor = lib.strings.removePrefix "#" color;
    in
    "#${cleanColor}${toHex opacity}";
in
{
  inherit withAlpha;

  colors = baseColors // {
    accent = currentAccent;
  };
  font = {
    base = f.monospace.name;
    mono = "${f.monospace.name} Mono";
    propo = "${f.monospace.name} Propo";
  };
  border = {
    radius = 8;
    width = 0;
  };
  spacing = {
    gapsIn = 3;
    gapsOut = 10;
  };
  opacity = {
    windowActive = 0.95;
    windowInactive = 0.85;
    popups = 0.7;
  };
  blur = {
    size = 6;
    passes = 2;
  };
}
