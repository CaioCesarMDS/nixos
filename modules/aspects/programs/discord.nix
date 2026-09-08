{ inputs, ... }:
{
  den.aspects.discord.homeManager =
    { pkgs, ... }:
    {
      imports = [ inputs.nixcord.homeModules.nixcord ];

      programs.nixcord = {
        enable = true;
        vesktop.enable = true;

        discord.silenceNoModClientWarning = true;

        config = {
          useQuickCss = true;
          frameless = true;
          plugins = {
            noTrack.enable = true;
            messageLogger = {
              enable = true;
              ignoreSelf = true;
            };
            fakeNitro.enable = true;
            callTimer.enable = true;
            volumeBooster.enable = true;
            fixImagesQuality.enable = true;
            readAllNotificationsButton.enable = true;
            silentMessageToggle.enable = true;
            platformIndicators.enable = true;
            relationshipNotifier.enable = true;
            memberCount.enable = true;
            spotifyControls.enable = true;
          };
        };
      };

      xdg.mimeApps = {
        defaultApplications = {
          "x-scheme-handler/discord" = [ "vesktop.desktop" ];
        };
      };
    };
}
