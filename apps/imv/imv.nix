{
  programs.imv = {
    enable = true;
    settings = {
      binds = {
        n = "next";
        p = "prev";
        "<bracketleft>" = "rotate by -90";
        "<bracketright>" = "rotate by 90";
        "<Shift+Delete>" = "exec rm \"$imv_current_file\"; close";
      };
      options.fullscreen = "true";
    };
  };
}
