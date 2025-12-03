{
  pkgs,
  unstablePkgs,
  ...
}:
pkgs.mkCustomShellNoCC {
  packages = with unstablePkgs; [
    vscode-json-languageserver
  ];
}
