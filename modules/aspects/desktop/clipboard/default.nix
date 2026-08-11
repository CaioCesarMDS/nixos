{ ... }:
{
  den.aspects.clipboard.homeManager = { pkgs, ... }: {
    imports = [
      ./_services.nix
    ];

    home.packages = with pkgs; [
      cliphist
      wl-clipboard
    ];
  };
}
