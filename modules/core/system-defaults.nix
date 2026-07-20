{ ... }:
{
  den.aspects.system-defaults.nixos =
    { ... }:
    {
      console.useXkbConfig = true;
      documentation.nixos.enable = false;
    };
}
