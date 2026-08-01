{ ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
          inter
          nerd-fonts.jetbrains-mono
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-cjk-sans
        ];
        fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [ "JetBrainsMono Nerd Font" ];
            sansSerif = [
              "Inter"
              "Noto Sans"
            ];
            serif = [ "Noto Serif" ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };
    };
}
