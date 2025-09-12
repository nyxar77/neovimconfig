{
  description = "multi-language devShells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) ["intelephense"];
        overlays = [
          (final: prev: {
            # mkCustomShellNoCC = prev.mkShellNoCC.override (oldAttrs: {
            #   packages = oldAttrs.packages ++ [pkgs.tree-sitter];
            # });
            mkCustomShellNoCC = args:
              prev.mkShellNoCC (args
                // {
                  packages = args.packages ++ [pkgs.tree-sitter];
                });
          })
        ];
      };

      mkImportShell = key: path: pkgs.lib.nameValuePair key (import ./shells/${path} {inherit pkgs;});
    in {
      devShells = builtins.listToAttrs [
        (mkImportShell "clang" "clang.nix")
        (mkImportShell "nix" "nix-lang.nix")
        (mkImportShell "lua" "lua.nix")
        (mkImportShell "go" "golang.nix")
        (mkImportShell "haskell" "haskell.nix")
        (mkImportShell "js" "javascript.nix")
        (mkImportShell "php" "php.nix")
        (mkImportShell "yaml" "yaml.nix")
        (mkImportShell "make" "make.nix")
      ];
      /*
       {
        clang = import ./shells/clang.nix {inherit pkgs;};
        nix = import ./shells/nix-lang.nix {inherit pkgs;};
        lua = import ./shells/lua.nix {inherit pkgs;};
        go = import ./shells/golang.nix {inherit pkgs;};
        haskell = import ./shells/haskell.nix {inherit pkgs;};
        js = import ./shells/javascript.nix {inherit pkgs;};
        php = import ./shells/php.nix {inherit pkgs;};
        yaml = import ./shells/yaml.nix {inherit pkgs;};
        make = import ./shells/make.nix {inherit pkgs;};
      };
      */
      /*
         buildInputs = with pkgs; [
        # Core tooling
        tree-sitter
        clang-tools

        # Language servers
        bash-language-server
        docker-language-server
        docker-compose-language-service
        emmet-language-server
        gopls
        haskell-language-server
        helm-ls
        hyprls
        intelephense
        lua-language-server
        taplo
        taplo-lsp
        tailwindcss-language-server
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server
        nixd

        # Linters / formatters
        css-checker
        csslint
        eslint_d
        stylua
        alejandra
        yamlfmt
        yamllint

        # Debuggers
        delve
        python312Packages.debugpy
        vscode-js-debug
      ];
      */
    });
}
