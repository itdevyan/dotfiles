return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Without smear
    --stiffness = 0.5,
    --trailing_stiffness = 0.5,
    --matrix_pixel_threshold = 0.5,
    -- Faster
    stiffness = 0.8,                      -- 0.6      [0, 1]
    trailing_stiffness = 0.6,             -- 0.45     [0, 1]
    stiffness_insert_mode = 0.7,          -- 0.5      [0, 1]
    trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
    damping = 0.95,                       -- 0.85     [0, 1]
    damping_insert_mode = 0.95,           -- 0.9      [0, 1]
    distance_stop_animating = 0.5,
    -- Fire hazard
    --cursor_color = "#e0c15a",
    --stiffness = 0.3,
    --trailing_stiffness = 0.1,
    --damping = 0.5,
    --trailing_exponent = 5,
    --never_draw_over_target = true,
    --hide_target_hack = true,
    --gamma = 1,

    -- Other options
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    legacy_computing_symbols_support = false,
    smear_insert_mode = true,
  },
}
