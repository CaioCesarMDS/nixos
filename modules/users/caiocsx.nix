{ den, ... }:
{
  den.aspects.caiocsx = {
    includes = [
      den.batteries.hostname
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")

      den.aspects.desktop

      den.aspects.zsh
      den.aspects.cli-tools
      den.aspects.git
      den.aspects.btop
      den.aspects.fastfetch
      den.aspects.direnv
      den.aspects.docker
      den.aspects.flatpak

      den.aspects.kitty
      den.aspects.thunar
      den.aspects.vscodium
      den.aspects.imv
      den.aspects.mpv
      # den.aspects.zathura
      den.aspects.qbittorrent
      den.aspects.spicetify
      den.aspects.vesktop
      den.aspects.zen-browser
    ];

    user =
      { ... }:
      {
        extraGroups = [
          "docker"
        ];
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          proton-vpn
          proton-pass
          protonmail-desktop
          gimp
          libresprite
          obsidian
          godot
          # bruno
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
