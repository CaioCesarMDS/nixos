{ ... }:
{
  den.aspects.mpv.homeManager =
    { pkgs, ... }:
    {
      programs.mpv = {
        enable = true;
        config = {
          hwdec = "auto";
          vo = "gpu";
          profile = "high-quality";
        };
      };
    };
}
