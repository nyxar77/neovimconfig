{pkgs}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    go
    gopls
    delve
  ];
}
