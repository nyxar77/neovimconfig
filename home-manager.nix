{ pkgs, ... }:
let
  # Nix plugin dependencies otherwise become start packages even when their
  # consumer is optional. Lua hooks below load each required dependency.
  withoutPluginDependencies = plugin: plugin // { dependencies = [ ]; };
  optionalPlugin = plugin: {
    plugin = withoutPluginDependencies plugin;
    optional = true;
  };

  notebookPythonPackages =
    pythonPackages: with pythonPackages; [
      ipykernel
      jupyter-client
      nbformat
      pillow
    ];

  moltenPlugin = pkgs.vimPlugins.molten-nvim.overrideAttrs {
    checkInputs = [ ];
    nvimSkipModules = [
      "load_image_nvim"
      "load_snacks_nvim"
      "load_wezterm_nvim"
    ];
  };

  moltenManifestPython = pkgs.python3.withPackages (
    pythonPackages: [ pythonPackages.pynvim ] ++ notebookPythonPackages pythonPackages
  );

  moltenManifest = pkgs.runCommand "molten-rplugin.vim" { } ''
    export HOME="$TMPDIR/home"
    export NVIM_RPLUGIN_MANIFEST="$out"
    mkdir -p "$HOME/.local/state/nvim"

    ${pkgs.neovim-unwrapped}/bin/nvim --headless -u NORC -i NONE \
      --cmd "set runtimepath^=${moltenPlugin}" \
      --cmd "lua vim.g.python3_host_prog='${moltenManifestPython}/bin/python3'" \
      +UpdateRemotePlugins +qa!

    grep -q MoltenInit "$out"
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = false;
    withRuby = false;
    sideloadInitLua = true;
    extraWrapperArgs = [
      "--set"
      "NVIM_RPLUGIN_MANIFEST"
      "${moltenManifest}"
    ];

    plugins = with pkgs.vimPlugins; [
      lz-n

      # LSP definitions are read before lazy plugin registration.
      (withoutPluginDependencies nvim-lspconfig)

      (optionalPlugin plenary-nvim)
      (optionalPlugin nvim-web-devicons)
      (optionalPlugin nvim-treesitter-textobjects)
      (optionalPlugin harpoon-lualine)
      (optionalPlugin nvim-nio)
      (optionalPlugin nvim-dap-go)
      (optionalPlugin telescope-dap-nvim)
      (optionalPlugin promise-async)

      (optionalPlugin nvim-lint)
      (optionalPlugin markview-nvim)

      jupytext-nvim
      moltenPlugin
      (optionalPlugin image-nvim)
      (optionalPlugin otter-nvim)
      (optionalPlugin quarto-nvim)

      (optionalPlugin telescope-nvim)
      (optionalPlugin telescope-live-grep-args-nvim)

      (optionalPlugin ccc-nvim)
      (optionalPlugin comment-nvim)
      (optionalPlugin todo-comments-nvim)
      (optionalPlugin nvim-ts-context-commentstring)
      (optionalPlugin cord-nvim)
      (optionalPlugin indent-blankline-nvim)
      (optionalPlugin oil-nvim)
      (optionalPlugin lualine-nvim)
      (optionalPlugin gitsigns-nvim)
      (optionalPlugin which-key-nvim)
      (optionalPlugin snacks-nvim)

      (optionalPlugin catppuccin-nvim)
      (optionalPlugin reactive-nvim)
      (nvim-treesitter.withPlugins (
        parsers: with parsers; [
          asm
          bash
          blade
          c
          cpp
          css
          desktop
          diff
          dockerfile
          fish
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          go
          graphql
          html
          hyprlang
          ini
          java
          javascript
          json
          latex
          lua
          luau
          markdown
          markdown_inline
          nginx
          nix
          php
          python
          rasi
          rust
          scss
          solidity
          toml
          tsx
          typescript
          typst
          xml
          yaml
          yuck
          zig
        ]
      ))

      (optionalPlugin harpoon2)

      (optionalPlugin auto-session)
      (optionalPlugin toggleterm-nvim)
      (optionalPlugin undotree)
      (optionalPlugin url-open)
      # vimtex

      # lazygit-nvim

      (optionalPlugin lazydev-nvim)
      (optionalPlugin SchemaStore-nvim)

      (optionalPlugin nvim-autopairs)
      (optionalPlugin nvim-cmp)
      (optionalPlugin cmp-nvim-lsp)
      (optionalPlugin cmp-path)
      (optionalPlugin cmp-buffer)
      (optionalPlugin cmp-cmdline)
      (optionalPlugin luasnip)
      (optionalPlugin cmp_luasnip)
      (optionalPlugin friendly-snippets)
      (optionalPlugin lspkind-nvim)

      (optionalPlugin conform-nvim)

      (optionalPlugin nvim-dap)
      (optionalPlugin nvim-dap-ui)
      (optionalPlugin nvim-dap-virtual-text)

      (optionalPlugin nvim-ufo)
    ];

    extraPython3Packages = notebookPythonPackages;

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
      nixfmt
      statix
      deadnix

      # Lua
      lua-language-server
      stylua

      # Bash
      bash-language-server
      shfmt

      # Web
      typescript-language-server
      vscode-langservers-extracted
      emmet-language-server
      tailwindcss-language-server
      biome
      css-variables-language-server
      graphql-language-service-cli

      # JSON/YAML
      yaml-language-server
      yamlfmt
      yamllint

      # Python
      basedpyright
      black
      isort
      imagemagick
      python3Packages.jupytext

      # Go
      go
      gopls

      # C / CMake
      # clang-tools # ~800 MiB; enable together with clangd in core/lsp.lua.
      neocmakelsp

      # Debug adapters (enable when needed)
      # delve
      # vscode-extensions.vadimcn.vscode-lldb.adapter
      # (python3.withPackages (pythonPackages: [ pythonPackages.debugpy ]))

      # Rust
      rust-analyzer

      # PHP
      intelephense

      # Java
      jdt-language-server

      # Docker / Helm / Nginx
      docker-language-server
      helm-ls
      nginx-language-server

      # SQL
      sqls

      # Assembly / Luau / Solidity
      asm-lsp
      luau-lsp
      vscode-solidity-server

      # Markdown / Typst / LaTeX
      marksman
      tinymist
      texlab

      prettier

      hyprls

      # agents
      codex
    ];
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

}
