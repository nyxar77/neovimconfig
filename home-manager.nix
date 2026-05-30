{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;

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
    ];
  };

  xdg.configFile."nvim" = {
    source = ./.;
    recursive = true;
  };
}
