return {
  'mistweaverco/bafa.nvim',
  version = 'v1.12.3',
  keys = {
    {
      '<leader><leader>',
      function() require('bafa').toggle({ with_jump_labels = true }) end,
      desc = 'Bafa: toggle buffer explorer',
    },
  },
  opts = {
    ui = {
      sort = {
        method = 'default', -- most recently used first
        focus_alternate_buffer = false,
      },
      diagnostics = true,
      line_numbers = false,
      border = 'rounded',
      style = 'minimal',
      position = { preset = 'center' },
    },
  },
}
