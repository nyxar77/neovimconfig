{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    nodejs
    eslint
    vscode-js-debug
  ];
}
