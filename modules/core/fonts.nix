{ ... }:
{
  den.aspects.fonts.nixos =
    { pkgs, ... }:
    {
      fonts = {
        fontDir.enable = true;
        packages = with pkgs; [
          dejavu_fonts
          liberation_ttf
          nerd-fonts.jetbrains-mono
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-cjk-sans
        ];
        fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [ "JetBrainsMono Nerd Font" ];
            serif = [ "Noto Serif" ];
            sansSerif = [ "Noto Sans" ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };
    };
}
