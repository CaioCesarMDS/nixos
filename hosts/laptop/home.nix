{ vars, ... }:

{
  imports = [
    ../../modules/home/core
    ../../modules/home/shell
    ../../modules/home/programs
    ../../modules/home/desktop/hyprland
  ];

  programs.home-manager.enable = true;

  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
    stateVersion = "25.11";
  };
}
