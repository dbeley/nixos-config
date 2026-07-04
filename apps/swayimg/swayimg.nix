{
  programs.swayimg.enable = true;

  xdg.configFile."swayimg/init.lua".text = ''
    -- General config
    -- Image list configuration
    swayimg.imagelist.enable_adjacent(true)

    -- Viewer mode
    swayimg.viewer.set_default_scale("fit")
    swayimg.viewer.limit_preload(5)

    -- Gallery mode
    swayimg.gallery.enable_preload(true)

    -- Key bindings - viewer mode
    swayimg.viewer.on_key("p", function()
      swayimg.viewer.switch_image("prev")
    end)
    swayimg.viewer.on_key("n", function()
      swayimg.viewer.switch_image("next")
    end)
    swayimg.viewer.on_key("h", function()
      local wnd = swayimg.get_window_size()
      local pos = swayimg.viewer.get_position()
      swayimg.viewer.set_abs_position(pos.x + math.floor(wnd.width / 10), pos.y)
    end)
    swayimg.viewer.on_key("j", function()
      local wnd = swayimg.get_window_size()
      local pos = swayimg.viewer.get_position()
      swayimg.viewer.set_abs_position(pos.x, pos.y - math.floor(wnd.height / 10))
    end)
    swayimg.viewer.on_key("k", function()
      local wnd = swayimg.get_window_size()
      local pos = swayimg.viewer.get_position()
      swayimg.viewer.set_abs_position(pos.x, pos.y + math.floor(wnd.height / 10))
    end)
    swayimg.viewer.on_key("l", function()
      local wnd = swayimg.get_window_size()
      local pos = swayimg.viewer.get_position()
      swayimg.viewer.set_abs_position(pos.x - math.floor(wnd.width / 10), pos.y)
    end)
    swayimg.viewer.on_key("w", function()
      swayimg.viewer.set_fix_scale("width")
    end)
    swayimg.viewer.on_key("W", function()
      swayimg.viewer.set_fix_scale("height")
    end)
    swayimg.viewer.on_key("z", function()
      swayimg.viewer.set_fix_scale("fit")
    end)
    swayimg.viewer.on_key("Z", function()
      swayimg.viewer.set_fix_scale("fill")
    end)
    swayimg.viewer.on_key("bracketleft", function()
      swayimg.viewer.rotate(270)
    end)
    swayimg.viewer.on_key("bracketright", function()
      swayimg.viewer.rotate(90)
    end)
    swayimg.viewer.on_key("d", function()
      if swayimg.text.visible() then
        swayimg.text.hide()
      else
        swayimg.text.show()
      end
    end)
    swayimg.viewer.on_key("D", function()
      if swayimg.text.visible() then
        swayimg.text.hide()
      else
        swayimg.text.show()
      end
    end)
    swayimg.viewer.on_key("i", function()
      local scale = swayimg.viewer.get_scale()
      swayimg.viewer.set_abs_scale(scale + 0.1)
    end)
    swayimg.viewer.on_key("u", function()
      local scale = swayimg.viewer.get_scale()
      swayimg.viewer.set_abs_scale(scale - 0.1)
    end)
    swayimg.viewer.on_key("r", function()
      swayimg.viewer.switch_image("random")
    end)
    swayimg.viewer.on_key("q", function()
      swayimg.exit()
    end)

    -- Key bindings - gallery mode
    swayimg.gallery.on_key("h", function()
      swayimg.gallery.switch_image("left")
    end)
    swayimg.gallery.on_key("j", function()
      swayimg.gallery.switch_image("down")
    end)
    swayimg.gallery.on_key("k", function()
      swayimg.gallery.switch_image("up")
    end)
    swayimg.gallery.on_key("l", function()
      swayimg.gallery.switch_image("right")
    end)
  '';
}
