{
  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
    settings = {
      horizontal = true;
      battery = true;
      cpu_stats = true;
      # core_load = true;
      # core_bars = true;
      cpu_temp = true;
      # cpu_power = true;
      gpu_stats = true;
      gpu_load = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      vram = true;
      ram = true;
      fps = true;
      table_columns = 14;
      frametime = 0;
      frame_timing = 1;
      hud_no_margin = true;
    };
  };
}
