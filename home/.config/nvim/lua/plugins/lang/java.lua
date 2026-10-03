return {
  "mfussenegger/nvim-jdtls",
  config = function()
    local default_inlay_hint_handler = vim.lsp.handlers["textDocument/inlayHint"]

    vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
      if err then
        local msg = err.message or ""
        if string.match(msg, "inlay hints failed") or err.code == -32802 or err.code == -32001 then
          return
        end
      end

      if default_inlay_hint_handler then
        return default_inlay_hint_handler(err, result, ctx, config)
      end
    end
  end,
}
