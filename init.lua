require("Nyxar");
--[[vim.cmd[[
  autocmd VimEnter * :lua RunScriptOnVimEnter()
]]--

function RunScriptOnVimEnter()
  -- Run your bash script here
  vim.fn.system('test.sh')
end

vim.g.mapleader = " "
