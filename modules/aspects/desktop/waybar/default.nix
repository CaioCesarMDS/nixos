{ ... }:
{
  den.aspects.waybar.homeManager =
    { ui, ... }:
    let
      settings = import ./_settings.nix { inherit ui; };
      style = import ./_style.nix { inherit ui; };
    in
    {
      imports = [ ./_services.nix ];

      programs.waybar = {
        enable = true;
        settings = {
          main = settings;
        };
        inherit style;
      };
    };
}
