{ ... }:
{
  den.aspects.time.nixos =
    { lib, ... }:
    {
      time.timeZone = lib.mkDefault "America/Recife";
      services.timesyncd.enable = lib.mkDefault true;
    };
}
