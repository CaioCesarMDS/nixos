{
  config,
  lib,
  pkgs,
  vars,
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

    profileExtra = lib.optionalString (vars.displayManager == "tty") ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
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

      nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nix-rebuild = "sudo nixos-rebuild switch --flake ${vars.configDir}/#${vars.hostname}";
      nix-update = "nix flake update --flake ${vars.configDir}";
      nix-upgrade = "nix flake update --flake ${vars.configDir} && sudo nixos-rebuild switch --flake ${vars.configDir}/#${vars.hostname}";
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
    ];
  };
}
