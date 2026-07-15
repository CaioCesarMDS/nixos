{ ... }:
{
  den.aspects.locale.nixos =
    { lib, ... }:
    {
      time.timeZone = "America/Recife";
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };
      };
      services.timesyncd.enable = lib.mkDefault true;
      services.xserver.enable = true;
      console.useXkbConfig = true;
    };
}
