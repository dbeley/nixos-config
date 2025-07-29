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
      };
    };
  };
}
