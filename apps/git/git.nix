{
  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        email = "6568955+dbeley@users.noreply.github.com";
        name = "dbeley";
      };
      diff = {
        algorithm = "patience";
        colorMoved = "zebra";
      };
      color = {
        ui = "auto";
        branch = "auto";
        diff = "auto";
        status = "auto";
        showbranch = "auto";
      };
      merge = {
        tool = "nvim";
        renamelimit = 20000;
      };
      mergetool = { prompt = false; };
      pull = { rebase = true; };
      rebase = { autoStash = true; };
      core = { autocrlf = "input"; };
      credential = { helper = "cache"; };
      init = { defaultBranch = "main"; };
      rerere = { enabled = true; };
      fetch = { prune = true; };
      push = { autoSetupRemote = false; };
    };
  };
}
