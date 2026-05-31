{ pkgs, colors, ... }:

pkgs.writeText "rofi-confirm.rasi" ''
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
    modi:                       "drun";
    show-icons:                 false;
    font:                       "JetBrainsMono Nerd Font 10";
  }

  window {
    location:               center;
    anchor:                 center;
    fullscreen:             false;
    width:                  20em;
    border-radius:          0.5em;
  }

  mainbox {
    children:               [ "message", "listview" ];
    background-color:       @background;
  }

  message {
    str:                    "Are you sure?";
    padding:                1.5em;
    text-color:             @foreground;
    background-color:       @background-alt;
  }

  textbox {
    background-color:       inherit;
    text-color:             inherit;
    vertical-align:         0.5;
    horizontal-align:       0.5;
  }

  listview {
    background-color:       @background;
    columns:                2;
    lines:                  1;
    padding:                1em;
    spacing:                1em;
  }

  element-text {
    horizontal-align:       0.5;
  }

  textbox {
    horizontal-align:       0.5;
  }

  element {
    padding:                16px 8px;
    border-radius:          12px;
    background-color:       @background-alt;
    text-color:             @foreground;
  }

  element-text {
    font:                   "JetBrainsMono Nerd Font 32";
    background-color:       transparent;
    text-color:             inherit;
    vertical-align:         0.5;
    horizontal-align:       0.5;
  }

  element selected.normal {
    background-color:       @accent-active;
    text-color:             @background-alt;
  }
''
