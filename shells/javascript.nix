{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    eslint
    vscode-js-debug
  ];
}
