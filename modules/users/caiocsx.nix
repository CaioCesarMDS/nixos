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
      den.aspects.wallpapers

      den.aspects.zsh
      den.aspects.cli-tools
      den.aspects.git
      den.aspects.btop
      den.aspects.fastfetch
      den.aspects.direnv
      den.aspects.docker
      den.aspects.flatpak

      den.aspects.quickshell
      den.aspects.kitty
      den.aspects.thunar
      den.aspects.vscodium
      den.aspects.imv
      den.aspects.mpv
      den.aspects.zathura
      den.aspects.qbittorrent
      den.aspects.spicetify
      den.aspects.vesktop
      den.aspects.zen-browser
    ];

    user =
      { ... }:
      {
        isNormalUser = true;
        # initialPassword = "123"; For tests in the VM
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
          gimp
          obsidian
          bruno
          onlyoffice-desktopeditors
        ];

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
