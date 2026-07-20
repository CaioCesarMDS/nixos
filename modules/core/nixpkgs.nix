{ inputs, ... }:

let
  nixpkgsConfig = {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
      permittedInsecurePackages = [
        "electron-39.8.10"
      ];
    };
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  };
in
{
  den.aspects.nixpkgs = {
    nixos = { ... }: {
      nixpkgs = nixpkgsConfig;
    };

    homeManager = { ... }: {
      nixpkgs = nixpkgsConfig;
    };
  };
}
