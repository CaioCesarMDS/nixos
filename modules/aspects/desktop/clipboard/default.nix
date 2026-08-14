{ ... }:
{
  den.aspects.clipboard.homeManager =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./_services.nix
      ];

      options.clipboard.maxItems = lib.mkOption {
        type = lib.types.int;
        default = 750;
        description = "Maximum number of items saved in the cliphist history.";
      };

      config = {
        home.packages = with pkgs; [
          cliphist
          wl-clipboard
        ];
      };
    };
}
