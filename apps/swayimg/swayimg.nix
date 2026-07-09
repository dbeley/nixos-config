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
    swayimg.viewer.on_key("S-Delete", function()
      local image = swayimg.viewer.get_image()
      if image then
        os.remove(image.path)
        swayimg.text.set_status("Deleted: " .. image.path)
        swayimg.viewer.switch_image("next")
      end
    end)

    -- Key bindings - gallery mode (vim-inspired)
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
    -- g/G: first/last
    swayimg.gallery.on_key("g", function()
      swayimg.gallery.switch_image("first")
    end)
    swayimg.gallery.on_key("G", function()
      swayimg.gallery.switch_image("last")
    end)
    -- Ctrl-d/Ctrl-u: page down/up
    swayimg.gallery.on_key("Ctrl-d", function()
      swayimg.gallery.switch_image("pgdown")
    end)
    swayimg.gallery.on_key("Ctrl-u", function()
      swayimg.gallery.switch_image("pgup")
    end)
    -- Enter/Space: open selected image in viewer
    swayimg.gallery.on_key("Return", function()
      swayimg.set_mode("viewer")
    end)
    swayimg.gallery.on_key("space", function()
      swayimg.set_mode("viewer")
    end)
    -- q/Escape: quit
    swayimg.gallery.on_key("q", function()
      swayimg.exit()
    end)
    swayimg.gallery.on_key("Escape", function()
      swayimg.exit()
    end)
    -- d: toggle text overlay
    swayimg.gallery.on_key("d", function()
      if swayimg.text.visible() then
        swayimg.text.hide()
      else
        swayimg.text.show()
      end
    end)
    -- R: reload gallery
    swayimg.gallery.on_key("R", function()
      swayimg.gallery.reload()
      swayimg.text.set_status("Gallery reloaded")
    end)
    -- m: toggle mark on selected image
    swayimg.gallery.on_key("m", function()
      swayimg.gallery.mark_image()
    end)
    -- S-Delete: delete selected image
    swayimg.gallery.on_key("S-Delete", function()
      local image = swayimg.gallery.get_image()
      if image then
        os.remove(image.path)
        swayimg.text.set_status("Deleted: " .. image.path)
        swayimg.gallery.reload()
      end
    end)
    -- Ctrl-p: print paths of all marked files
    swayimg.gallery.on_key("Ctrl-p", function()
      local entries = swayimg.imagelist.get()
      for _, entry in ipairs(entries) do
        if entry.mark then
          print(entry.path)
        end
      end
    end)

    -- Key bindings - viewer mode additions
    -- Escape: go back to gallery mode
    swayimg.viewer.on_key("Escape", function()
      swayimg.set_mode("gallery")
    end)
  '';
}
