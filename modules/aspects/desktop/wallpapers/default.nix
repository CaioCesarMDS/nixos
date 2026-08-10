{ ... }:
{
  den.aspects.wallpapers.homeManager = { ... }: {
    imports = [
      ./_base.nix
      ./_services.nix
    ];
  };
}
