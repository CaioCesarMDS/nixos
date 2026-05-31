{ ... }:

{
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
}
