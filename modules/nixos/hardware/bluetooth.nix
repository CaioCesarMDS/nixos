{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        MultiProfile = "multiple";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;
}
