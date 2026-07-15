{ ... }:
{
  den.aspects.cli-utils = {

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          bat
          cmatrix
          fd
          ripgrep
        ];

        programs.eza = {
          enable = true;
          enableZshIntegration = true;
          git = true;
          colors = "always";
          icons = "always";
          extraOptions = [
            "--group-directories-first"
            "--no-quotes"
            "--header"
            "--git-ignore"
            "--time-style=long-iso"
            "--classify"
            "--hyperlink"
          ];
        };

        programs.fzf = {
          enable = true;
          enableZshIntegration = true;
          defaultCommand = "fd --type f";
          defaultOptions = [
            "--height=40%"
            "--layout=reverse"
            "--border"
            "--info=inline"
          ];
          fileWidgetOptions = [
            "--walker-skip=.git,node_modules,target,dist,.direnv,result"
            "--preview 'bat -n --color=always {} || cat {}'"
            "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
          ];
          historyWidgetOptions = [
            "--style=full"
          ];
        };

        programs.starship = {
          enable = true;
          enableZshIntegration = true;
          presets = [
            "nerd-font-symbols"
          ];
        };

        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
      };
  };
}
