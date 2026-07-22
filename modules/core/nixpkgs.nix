{ inputs, lib, ... }:
let
  nixpkgsConfig = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "spotify"
          "obsidian"
        ];

      nvidia.acceptLicense = true;
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
