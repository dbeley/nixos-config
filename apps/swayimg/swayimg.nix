{
  programs.swayimg = {
    enable = true;
    settings = {
      general = {
        mode = "viewer";
        size = "parent";
      };
      viewer = {
        scale = "fit";
        preload = 5;
      };
      list = {
        all = "yes";
      };
      "keys.viewer" = {
        p = "prev_file";
        n = "next_file";
        h = "step_left 10";
        j = "step_down 10";
        k = "step_up 10";
        l = "step_right 10";
        w = "zoom width";
        "Shift+w" = "zoom height";
        z = "zoom fit";
        "Shift+z" = "zoom fill";
        bracketleft = "rotate_left";
        bracketright = "rotate_right";
        d = "info";
        "Shift+d" = "info";
        i = "zoom +10";
        u = "zoom -10";
        r = "rand_file";
      };
      "keys.gallery" = {
        h = "step_left";
        j = "step_down";
        k = "step_up";
        l = "step_right";
        
      };
    };
  };
}
