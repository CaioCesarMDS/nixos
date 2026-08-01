{ ... }:
{
  den.aspects.git.homeManager =
    { ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
          pull.rebase = true;
          rebase.autoStash = true;
          fetch.prune = true;
          push.autoSetupRemote = true;
        };
      };
    };
}
