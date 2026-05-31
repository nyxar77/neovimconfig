{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      nvim-lint

      telescope-nvim
      telescope-live-grep-args-nvim
      plenary-nvim
      nvim-web-devicons

      ccc-nvim
      comment-nvim
      todo-comments-nvim
      nvim-ts-context-commentstring
      cord-nvim
      indent-blankline-nvim
      oil-nvim
      lualine-nvim
      gitsigns-nvim
      which-key-nvim
      snacks-nvim

      catppuccin-nvim
      #reactive-nvim
      nvim-treesitter
      nvim-treesitter-textobjects

      harpoon2
      # add this package "letieu/harpoon-lualine"

      toggleterm-nvim
      undotree
      url-open
      # vimtex

      lazygit-nvim

      lazydev-nvim
      SchemaStore-nvim

      nvim-autopairs
      nvim-cmp # autocompletion
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-cmdline
      nvim-lspconfig # deprecated
      luasnip
      cmp_luasnip
      friendly-snippets
      lspkind-nvim

      conform-nvim # formatters

      nvim-nio # dap
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim

      nvim-ufo # folds
      promise-async

      lz-n # lazy loading
    ];

    extraPackages = with pkgs; [
      # Core Neovim tools
      git
      ripgrep
      fd
      tree-sitter
      gcc
      gnumake
      unzip

      # Nix
      nixd
      nil
      alejandra
      statix
      deadnix

      # Lua
      lua-language-server
      stylua
      emmylua-ls
      emmylua-check
      emmylua-doc-cli

      # Bash
      bash-language-server
      shfmt

      # Web
      typescript-language-server
      vscode-langservers-extracted
      emmet-language-server
      tailwindcss-language-server
      biome

      # JSON/YAML
      yaml-language-server
      yamlfmt
      yamllint

      # Python
      basedpyright
      black
      isort

      # Go
      gopls
      delve

      # Rust
      /*
         (inputs.fenix.packages.x86_64-linux.stable.withComponents [
        "rustc"
        "cargo"
        "clippy"
        "rustfmt"
        "rust-src"
      ])
      inputs.fenix.packages.x86_64-linux.stable.rust-analyzer
      pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
      */

      # PHP
      intelephense

      # Java
      jdt-language-server

      # SQL
      sqls

      # Markdown / Typst / LaTeX
      marksman
      tinymist
      texlab

      prettier

      # agents
      codex
    ];
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
