{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    typescript-language-server
    nodejs
    eslint
    vscode-langservers-extracted
    vscode-js-debug
  ];
}
