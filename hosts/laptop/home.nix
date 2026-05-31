{ vars, ... }:

{
  imports = [
    ../../modules/home/core
  ];

  programs.home-manager.enable = true;

  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
    stateVersion = "25.11";
  };
}
