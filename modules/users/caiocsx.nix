{ den, ... }:
{
  den.aspects.caiocsx = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")

      den.aspects.ly
      den.aspects.hyprland
      den.aspects.hypridle
      den.aspects.hyprlock
      den.aspects.rofi
      den.aspects.swaync
      den.aspects.waybar
      den.aspects.theme
      den.aspects.xdg
      den.aspects.zsh
      den.aspects.cli-utils
      den.aspects.docker
      den.aspects.flatpak
      den.aspects.thunar
      den.aspects.kitty
      den.aspects.git
      den.aspects.btop
      den.aspects.fastfetch
      den.aspects.mpv
      den.aspects.spicetify
      den.aspects.vesktop
      den.aspects.zen-browser
    ];

    user =
      { ... }:
      {
        isNormalUser = true;
        # initialPassword = "123456";
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          proton-vpn
          proton-pass
          proton-authenticator
          protonmail-desktop
          vscodium
          qbittorrent
          logseq
          bruno
          imv
        ];

        home.sessionVariables = {
          EDITOR = "codium";
          TERMINAL = "kitty";
        };

        programs.git = {
          settings = {
            user = {
              name = "caiocsx";
              email = "caiocesarsts@gmail.com";
            };
          };
        };
      };
  };
}
