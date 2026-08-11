{ ... }:
{
  den.aspects.hyprsunset.homeManager =
    { pkgs, ... }:
    let
      hyprsunsetToggle = import ./scripts/_hyprsunset-toggle.nix { inherit pkgs; };
    in
    {
      imports = [ ./_services.nix ];

      home.packages = [
        pkgs.hyprsunset
        hyprsunsetToggle
      ];
    };
}
