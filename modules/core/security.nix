{ ... }:
{
  den.aspects.security.nixos =
    { ... }:
    {
      security = {
        polkit.enable = true;
      };
    };
}
