{ den, ... }:
{
  den.aspects.swaync.homeManager =
    { pkgs, ui, ... }:
    let
      settings = import ./_settings.nix { };
      style = import ./_style.nix { inherit ui; };
    in
    {
      home.packages = with pkgs; [
        libnotify
      ];

      services.swaync = {
        enable = true;
        inherit settings style;
      };
    };
}
