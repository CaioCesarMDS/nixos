{ ... }:
{
  den.aspects.direnv.homeManager =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
}
