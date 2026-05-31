{
  hostname = "caio-nixos";
  username = "caiocsx";
  timezone = "America/Recife";
  locale = "en_US.UTF-8";

  configDir = "/home/caiocsx/nixos";

  gitUsername = "caiocsx";
  gitUserEmail = "";

  gpu = "amd"; # nvidia / amd

  keyboardLayout = "br"; # br / us / etc.
  keyboardVariant = "abnt2"; # abnt2 (Brazilian) / intl (International) / etc.

  displayManager = "ly"; # sddm / ly / tty
  autoLogin = false;
  sddmTheme = "hyprland_kath"; # black-hole / cyberpunk / hyprland_kath / jake_the_dog / japonese_aesthetic / pixel_sakura / pixel_sakura_static / post-apocalyptic_hacker / purple-leaves

  enableGaming = false;
  enableOllama = false;
  enableVirtualMachines = false;
}
