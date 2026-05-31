{
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
}
