{ ... }:
{
  den.aspects.sddm.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.services.displayManager.sddm.astronaut;

      customSddmAstronaut = pkgs.sddm-astronaut.override {
        embeddedTheme = cfg.theme;
      };

    in
    {
      options.services.displayManager.sddm.astronaut = {
        theme = lib.mkOption {
          type = lib.types.enum [
            "astronaut"
            "black_hole"
            "cyberpunk"
            "hyprland_kath"
            "jake_the_dog"
            "japanese_aesthetic"
            "pixel_sakura"
            "pixel_sakura_static"
            "post-apocalyptic_hacker"
            "purple_leaves"
          ];
          default = "pixel_sakura";
          description = "Built-in theme for sddm-astronaut.";
        };
      };

      config = {
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
    };
}
