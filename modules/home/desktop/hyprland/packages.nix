{ pkgs, ... }:

{
  home.packages = with pkgs; [
    awww
    cliphist
    hyprshot
    hyprpicker
    hyprsunset
    hyprcursor
    wl-clipboard
    playerctl
    brightnessctl
  ];
}
