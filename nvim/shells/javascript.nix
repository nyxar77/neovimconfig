{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    vscode-js-debug
  ];
}
