{ ... }:
{
  den.aspects.nix = {
    nixos =
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
            options = "--delete-older-than 7d";
          };
          optimise.automatic = true;
          package = pkgs.nixVersions.latest;
        };

        nixpkgs.config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        };
      };

    homeManager =
      { ... }:
      {
        nixpkgs.config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        };
      };
  };
}
