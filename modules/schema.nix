{ lib, ... }:
{
  den.schema.user.imports = [
    (_: {
      options = {
        city = lib.mkOption {
          type = lib.types.str;
          default = "Recife";
          description = "City used for weather-related widgets.";
        };
      };
    })
  ];
}
