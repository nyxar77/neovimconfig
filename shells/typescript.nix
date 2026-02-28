{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    typescript
    typescript-language-server
    biome
    vscode-langservers-extracted
    # eslint
  ];
}
