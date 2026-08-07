{ ... }:
{
  den.default.homeManager = { config, ... }: {
    _module.args.ui = import ./_ui.nix { inherit config; };
  };
}
