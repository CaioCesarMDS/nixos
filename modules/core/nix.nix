{ ... }:
{
  den.aspects.nix.nixos =
    { pkgs, ... }:
    {
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          keep-outputs = true;
          keep-derivations = true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };
        optimise.automatic = true;
        package = pkgs.nixVersions.stable;
      };
    };
}
