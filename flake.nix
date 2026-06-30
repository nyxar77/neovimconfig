{
  description = "Nyxar Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {unstable, ...}: let
    harpoonLualineOverlay = final: prev: let
      unstablePkgs = import unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (prev.lib.getName pkg) [
            "harpoon-lualine"
          ];
      };
    in {
      vimPlugins =
        prev.vimPlugins
        // {
          harpoon-lualine = unstablePkgs.vimPlugins.harpoon-lualine;
        };
    };
  in {
    overlays.default = harpoonLualineOverlay;
    homeManagerModules.default = import ./home-manager.nix;
  };
}
# // flake-utils.lib.eachDefaultSystem (system: let
#   unstablePkgs = import nixpkgs-unstable {inherit system;};
#   commonPkgs = [pkgs.tree-sitter];
#   pkgs = import nixpkgs {
#     inherit system;
#     config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) ["intelephense"];
#     overlays = [
#       (final: prev: {
#         mkCustomShellNoCC = args:
#           prev.mkShellNoCC (args
#             // {
#               packages = (args.packages or []) ++ commonPkgs;
#               # shellHook =
#               #   (args.shellHook or "")
#               #   + ''
#               #     if [ -x "${pkgs.starship}/bin/starship" ]; then
#               #      case "$SHELL" in
#               #        */zsh) eval "$(${pkgs.starship}/bin/starship init zsh)" ;;
#               #        */bash) eval "$(${pkgs.starship}/bin/starship init bash)" ;;
#               #      esac
#               #      fi
#               #   '';
#             });
#       })
#     ];
#   };
#
#   mkImportShell = key: path:
#     pkgs.lib.nameValuePair key (pkgs.callPackage ./shells/${path} {
#       inherit
#         self
#         pkgs
#         unstablePkgs
#         system
#         inputs
#         ;
#     });
# in {
#   packages.prettier = pkgs.prettier;
#      devShells = builtins.listToAttrs [
#     (mkImportShell "clang" "clang.nix")
#     (mkImportShell "py" "python.nix")
#     (mkImportShell "nix" "nix-lang.nix")
#     (mkImportShell "lua" "lua.nix")
#     (mkImportShell "go" "golang.nix")
#     (mkImportShell "haskell" "haskell.nix")
#     (mkImportShell "php" "php.nix")
#     (mkImportShell "web" "web.nix")
#     (mkImportShell "js" "javascript.nix")
#     (mkImportShell "json" "json.nix")
#     (mkImportShell "ts" "typescript.nix")
#     (mkImportShell "jsweb" "jsweb.nix")
#     (mkImportShell "yaml" "yaml.nix")
#     (mkImportShell "make" "make.nix")
#     (mkImportShell "asm" "assembly.nix")
#     (mkImportShell "sql" "sql.nix")
#     (mkImportShell "bash" "bash.nix")
#     (mkImportShell "docker" "docker.nix")
#     (mkImportShell "markdown" "markdown.nix")
#     (mkImportShell "latex" "latex.nix")
#     (mkImportShell "typst" "typst.nix")
#     (mkImportShell "rs" "rust.nix")
#     (mkImportShell "java" "java.nix")
#   ];
# });

