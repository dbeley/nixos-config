{
  programs.imv = {
    enable = true;
    settings = {
      binds.n = "next";
      binds.p = "prev";
      options.fullscreen = "true";
      binds."<bracketleft>" = "rotate by -90";
      binds."<bracketright>" = "rotate by 90";
      binds."<Shift+Delete>" = "exec rm \"$imv_current_file\"; close";
    };
  };
}
