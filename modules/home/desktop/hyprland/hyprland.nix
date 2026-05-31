{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    configType = "lua";
  };

  services = {
    hyprpolkitagent = {
      enable = true;
    };
  };
}
