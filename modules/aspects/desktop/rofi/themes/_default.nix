{ config, pkgs, ui }:
{
  confirmTheme = pkgs.writeText "confirm.rasi" (
    import ./_confirm.nix { inherit ui; }
  );

  passwordTheme = pkgs.writeText "password.rasi" (
    import ./_password.nix { inherit ui; }
  );

  listMenuTheme = pkgs.writeText "list-menu.rasi" (
    import ./_list-menu.nix { inherit ui; }
  );

  powerMenuTheme = pkgs.writeText "power-menu.rasi" (
    import ./_power-menu.nix { inherit config ui; }
  );

  launcherTheme = pkgs.writeText "launcher.rasi" (
    import ./_launcher.nix { inherit config ui; }
  );

  calculatorTheme = pkgs.writeText "calculator.rasi" (
    import ./_calculator.nix { inherit ui; }
  );

  wallpaperPickerTheme = pkgs.writeText "wallpaper-picker.rasi" (
    import ../themes/_wallpaper-picker.nix { inherit ui; }
  );
}
