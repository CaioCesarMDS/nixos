{ ... }:
{
  den.aspects.system-defaults.nixos =
    { lib, ... }:
    {
      console.useXkbConfig = true;
      documentation.nixos.enable = lib.mkDefault false;
    };
}
