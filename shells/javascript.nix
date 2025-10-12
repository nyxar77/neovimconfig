{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    typescript-language-server
    nodejs
    eslint
    vscode-js-debug
  ];
}
