{ ... }:

{
  programs.vesktop = {
    enable = true;
    vencord = {
      themes = {
        "ultra.theme.css" = ''
          @import url("https://raw.githubusercontent.com/TheCommieAxolotl/BetterDiscord-Stuff/0cef4643ae6a0ea9cc4914c41d9a42c51295e532/Ultra/Ultra.theme.css");
        '';
      };
      settings = {
        enabledThemes = [
          "ultra.theme.css"
        ];
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
        "pt-BR"
        "en-US"
      ];
      audio = {
        deviceSelect = true;
        granularSelect = true;
        ignoreVirtual = false;
        onlyDefaultSpeakers = false;
      };
    };
  };
}
