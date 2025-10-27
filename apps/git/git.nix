{
  programs.git = {
    enable = true;
    settings = {
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
      mergetool = {
        prompt = false;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      core = {
        autocrlf = "input";
      };
      credential = {
        helper = "cache";
      };
      init = {
        defaultBranch = "main";
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      fetch = {
        prune = true;
      };
      push = {
        autoSetupRemote = true;
      };
      column = {
        ui = "auto";
      };
    };
  };
}
