{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    emmet-language-server
    vscode-langservers-extracted
  ];
}
