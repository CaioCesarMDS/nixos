{ ... }:
{
  den.aspects.vesktop.homeManager =
    { pkgs, ... }:
    {
      programs.vesktop = {
        enable = true;
        vencord = {
          settings = {
            plugins = {
              MessageLogger = {
                enabled = true;
                ignoreSelf = true;
              };
              FakeNitro.enabled = true;
              CallTimer.enabled = true;
            };
          };
        };
        settings = {
          discordBranch = "stable";
          tray = true;
          minimizeToTray = true;
          clickTrayToShowHide = true;
          appBadge = true;
          enableTaskbarFlashing = false;
          staticTitle = true;
          customTitleBar = false;
          disableSmoothScroll = false;
          hardwareAcceleration = true;
          hardwareVideoAcceleration = true;
          arRPC = true;
          disableMinSize = true;
          openLinksWithElectron = false;
          splashTheming = true;
          splashColor = "#cdd6f4";
          splashBackground = "#1e1e2e";
          transparencyOption = "mica";
          spellCheckLanguages = [
            "en-US"
            "pt-BR"
          ];
          audio = {
            deviceSelect = true;
            granularSelect = true;
            ignoreVirtual = false;
            onlyDefaultSpeakers = false;
          };
        };
      };
    };
}
