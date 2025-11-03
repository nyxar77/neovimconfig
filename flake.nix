{
  description = "multi-language devShells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      unstablePkgs = import nixpkgs-unstable {inherit system;};
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
                  packages = (args.packages or []) ++ [pkgs.tree-sitter];
                  # shellHook =
                  #   (args.shellHook or "")
                  #   + ''
                  #     if [ -x "${pkgs.starship}/bin/starship" ]; then
                  #      case "$SHELL" in
                  #        */zsh) eval "$(${pkgs.starship}/bin/starship init zsh)" ;;
                  #        */bash) eval "$(${pkgs.starship}/bin/starship init bash)" ;;
                  #      esac
                  #      fi
                  #   '';
                });
          })
        ];
      };

      mkImportShell = key: path:
        pkgs.lib.nameValuePair key (import ./shells/${path} {
          inherit
            pkgs
            unstablePkgs
            ;
        });
    in {
      devShells = builtins.listToAttrs [
        (mkImportShell "clang" "clang.nix")
        (mkImportShell "nix" "nix-lang.nix")
        (mkImportShell "lua" "lua.nix")
        (mkImportShell "go" "golang.nix")
        (mkImportShell "haskell" "haskell.nix")
        (mkImportShell "php" "php.nix")
        (mkImportShell "web" "web.nix")
        (mkImportShell "js" "javascript.nix")
        (mkImportShell "ts" "typescript.nix")
        # (mkImportShell "jsweb" "jsweb.nix")
        (mkImportShell "yaml" "yaml.nix")
        (mkImportShell "make" "make.nix")
        (mkImportShell "asm" "assembly.nix")
        (mkImportShell "sql" "sql.nix")
      ];
    });
}
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

