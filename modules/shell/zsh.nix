{ ... }:
{
  den.aspects.zsh = {
    nixos =
      { ... }:
      {
        programs.zsh.enable = true;
      };

    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      {
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          dotDir = "${config.xdg.configHome}/zsh";

          history = {
            size = 10000;
            save = 10000;
            ignoreAllDups = true;
            ignoreDups = true;
            ignoreSpace = true;
            path = "${config.xdg.cacheHome}/zsh/history";
          };

          initContent = ''
            setopt share_history
            setopt correct

            zstyle ':fzf-tab:*' use-fzf-default-opts yes
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
          '';

          shellAliases = {
            c = "clear";
            h = "history";
            ff = "fastfetch";

            ls = "eza --no-filesize --no-time --no-user --no-permissions";
            ll = "eza -lh";
            la = "eza -a";
            lah = "eza -lah";
            lt = "eza -aT";

            nix-check = "nix flake check";
            nix-write = "nix run .#write-flake";
            nix-clean = "nh clean all";
            nix-rebuild = "nh os switch ~/nixos";
            nix-update = "nix flake update --flake ~/nixos";
            nix-upgrade = "nix flake update --flake ~/nixos && nh os switch ~/nixos";
          };

          plugins = [
            {
              name = "fzf-tab";
              src = pkgs.zsh-fzf-tab + "/share/fzf-tab";
            }
            {
              name = "you-should-use";
              src = pkgs.zsh-you-should-use + "/share/zsh/plugins/you-should-use";
            }
            {
              name = "autopair";
              src = pkgs.zsh-autopair;
              file = "share/zsh/zsh-autopair/autopair.zsh";
            }
          ];
        };
      };
  };
}
