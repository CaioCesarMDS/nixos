{ ... }:
{
  xdg.dataFile = {
    "applications/rofi.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Rofi
      Exec=true
      NoDisplay=true
    '';

    "applications/rofi-theme-selector.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Rofi Theme Selector
      Exec=true
      NoDisplay=true
    '';
  };
}
