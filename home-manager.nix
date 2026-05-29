{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      tree-sitter
      ripgrep
      fd
      git

      # LSPs
      lua-language-server
      nixd
      nil
      bash-language-server
      vscode-langservers-extracted
      typescript-language-server
      pyright
      gopls
      rust-analyzer
    ];
  };

  xdg.configFile."nvim" = {
    source = ./.;
    recursive = true;
  };
}
