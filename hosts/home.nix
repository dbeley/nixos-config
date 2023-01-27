{ config, pkgs, user, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user;
  home.homeDirectory = "/home/${user}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    keepassxc
    nextcloud-client
    libreoffice-fresh
    git
    tmux
    p7zip
    rsync
    ncdu
    htop
    stow
    ripgrep
    exa
    bat
    neofetch
    ];
  
  home.file = {
    ".config/git/config".text = ''
    [user]
  	email = 6568955+dbeley@users.noreply.github.com
  	name = dbeley
    [filesystem "N/A|13|/dev/mapper/SSD-root"]
    	timestampResolution = 8000 nanoseconds
    	minRacyThreshold = 6477 microseconds
    [diff]
    	algorithm = patience
    	colorMoved = zebra
    [color]
    	ui = auto
    	branch = auto
    	diff = auto
    	status = auto
        showbranch = auto
    
    # define command which will be used when "nvim" is set as a merge tool
    [mergetool "nvim"]
        cmd = nvim -f -c \"Gdiffsplit!\" \"$MERGED\"
    # set "nvim" as tool for merging
    [merge]
        tool = nvim
        renamelimit = 20000
    # automatically launch merge tool without displaying a prompt
    [mergetool]
        prompt = false
    [pull]
    	rebase = true
    [rebase]
    	autoStash = true
    [core]
    	autocrlf = input
    [credential]
    	helper = cache
    [filter "lfs"]
    	process = git-lfs filter-process
    	required = true
    	clean = git-lfs clean -- %f
    	smudge = git-lfs smudge -- %f
    [init]
    	defaultBranch = main
    [rerere]
    	enabled = true
    [fetch]
    	prune = true
    [push]
    	autoSetupRemote = false

    '';
  };
}
