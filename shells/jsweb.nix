{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    nodejs_24
    bun
    emmet-language-server
    vscode-langservers-extracted
  ];
}
