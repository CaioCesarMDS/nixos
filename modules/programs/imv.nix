{ ... }:
{
  den.aspects.imv.homeManager =
    { pkgs, ... }:
    {
      programs.imv = {
        enable = true;
      };

      xdg.mimeApps.defaultApplications = {
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/svg+xml" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/heif" = "imv.desktop";
      };
    };
}
