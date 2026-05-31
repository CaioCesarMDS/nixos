{ vars, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = vars.gitUsername;
        email = vars.gitUserEmail;
      };
      init.defaultBranch = "main";
    };
  };
}
