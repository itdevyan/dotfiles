vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then
      return
    end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false})
    end

    -- Disable semantic highlights
    client.server_capabilities.semanticTokensProvider = nil

    local opts = { buffer = event.buf }
    local builtin = require('telescope.builtin')

    opts.desc = "Show hover"
    --vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover({
        border = "rounded",
      })
    end, { buffer = bufnr })

    opts.desc = "Show definitions"
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)

    opts.desc = "Show declarations"
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = "Show implementations"
    vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)

    opts.desc = "Show references"
    vim.keymap.set('n', 'gr', builtin.lsp_references, opts)

    opts.desc = "Show workspace symbos"
    vim.keymap.set('n', 'gs', builtin.lsp_workspace_symbols, opts)

    opts.desc = "Rename"
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'x' }, '=', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

    opts.desc = "Actions"
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "g]", '<cmd>lua vim.diagnostic.jump({count=1, float=true})<cr>', opts)
    vim.keymap.set("n", "g[", '<cmd>lua vim.diagnostic.jump({count=-1, float=true})<cr>', opts)

  end,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        disable = {
          "undefined-global",
          "undefined-field"
        }
      },
    }
  }
})

vim.lsp.config('ts_ls', {
  on_attach = function(client)
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function(args)
    require 'jdtls.jdtls_setup'.setup()
  end
})
