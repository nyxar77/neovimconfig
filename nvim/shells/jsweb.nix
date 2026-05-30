{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    bun
    emmet-language-server
    # vscode-langservers-extracted
  ];
}
