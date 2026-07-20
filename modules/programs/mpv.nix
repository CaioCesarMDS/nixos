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

      xdg = {
        mimeApps.defaultApplications = {
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/ogg" = "mpv.desktop";
          "video/quicktime" = "mpv.desktop";
          "video/x-flv" = "mpv.desktop";
          "video/x-msvideo" = "mpv.desktop";
          "video/x-ms-wmv" = "mpv.desktop";
          "video/mpeg" = "mpv.desktop";

          "audio/mpeg" = "mpv.desktop";
          "audio/flac" = "mpv.desktop";
          "audio/ogg" = "mpv.desktop";
          "audio/wav" = "mpv.desktop";
          "audio/mp4" = "mpv.desktop";
          "audio/x-m4a" = "mpv.desktop";
        };

        dataFile."applications/mpv.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Name=mpv
          Exec=mpv %U
          NoDisplay=true
        '';
      };
    };
}
