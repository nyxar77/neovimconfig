local options = {	
    -- Cursor shape "wide"
   -- guicursor = "",
  
    -- Line numbers
   nu = true,
   relativenumber = true,
   
   -- tabs
   tabstop = 4,
   softtabstop = 4,
   shiftwidth = 4,
   expandtab = true,

   smartindent = true,
   wrap = false,

    -- backups
   swapfile = false,
   backup = false,
   undodir = os.getenv("HOME").."/.vim/undodir",
   undofile = true,

    -- search operations
   hlsearch = false,
   incsearch = true,

   -- gui colors
   termguicolors = true,

    scrolloff = 8,
    signcolumn= "no",
   
   updatetime = 50,
   colorcolumn = "0", 
}

for k , v in pairs(options)do
	vim.opt[k] = v
end


vim.g.mapleader = " "




