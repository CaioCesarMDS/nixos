{ ... }:
{
  den.aspects.sddm.nixos =
    { pkgs, ... }:

    let
      customSddmAstronaut = pkgs.sddm-astronaut.override {
        embeddedTheme = "pixel_sakura";
      };
    in
    {
      environment.systemPackages = [
        customSddmAstronaut
      ];

      services.displayManager = {
        defaultSession = "hyprland";
        sddm = {
          enable = true;
          wayland.enable = true;
          package = pkgs.kdePackages.sddm;
          theme = "sddm-astronaut-theme";
          extraPackages = with pkgs; [
            kdePackages.qtsvg
            kdePackages.qtvirtualkeyboard
            kdePackages.qtmultimedia
          ];
        };
      };
    };
}
