{ inputs, ... }:
let
  nixpkgsConfig = {
    config = {
      allowUnfree = true;
    };
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  };
in
{
  den.aspects.nixpkgs.nixos = { ... }: {
    nixpkgs = nixpkgsConfig;
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
