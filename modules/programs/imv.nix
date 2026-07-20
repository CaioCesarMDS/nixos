{ ... }:
{
  den.aspects.imv.homeManager =
    { pkgs, ... }:
    {
      programs.imv = {
        enable = true;
      };
    };
}
