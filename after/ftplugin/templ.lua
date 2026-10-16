vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 0
vim.bo.commentstring = '<!-- %s -->'

local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('templ-generate-' .. buf, { clear = true }),
  buffer = buf,
  callback = function(args)
    if vim.fn.executable 'templ' == 0 then return end
    vim.system({ 'templ', 'generate', '-f', vim.api.nvim_buf_get_name(args.buf) }, { text = true }, function(res)
      if res.code ~= 0 then
        vim.schedule(function() vim.notify('templ generate failed:\n' .. (res.stderr or ''), vim.log.levels.ERROR) end)
      end
    end)
  end,
})
