{ ... }:
{
  den.default.homeManager = { config, lib, ... }: {
    _module.args.ui = import ./_ui.nix {
      inherit config lib;
    };
  };
}
