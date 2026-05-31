{
  lib,
  pkgs,
  vars,
  ...
}:

let
  customSddmAstronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = vars.sddmTheme;
  };

  displayManager =
    if vars.displayManager == "sddm" then
      {
        sddm = {
          enable = true;
          wayland.enable = true;

          package = pkgs.kdePackages.sddm;
          theme = "sddm-astronaut-theme";

          extraPackages = with pkgs; [
            customSddmAstronaut
            kdePackages.qtsvg
            kdePackages.qtvirtualkeyboard
            kdePackages.qtmultimedia
          ];
        };
      }
    else if vars.displayManager == "ly" then
      {
        ly = {
          enable = true;
          x11Support = false;
          settings = {
            animation = "doom";
            clock = "%H:%M";
            hide_borders = false;
            hide_key_hints = false;
            save = true;
            load = true;
            bigclock = true;
            numlock = true;
            default_input = "password";
          };
        };
      }
    else
      {
      };
in
{
  services.displayManager = {
    defaultSession = "hyprland";
  }
  // lib.optionalAttrs vars.autoLogin {
    autoLogin = {
      enable = true;
      user = vars.username;
    };
  }
  // displayManager;

  environment.systemPackages =
    with pkgs;
    lib.optionals (vars.displayManager == "sddm") [
      customSddmAstronaut
    ];
}
