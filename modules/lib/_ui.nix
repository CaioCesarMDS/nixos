{ config, ... }:

let
  f = config.stylix.fonts;
  c = config.lib.stylix.colors.withHashtag;
in
{
  colors = {
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
