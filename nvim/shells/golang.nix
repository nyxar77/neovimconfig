{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    go
    gopls
    delve
  ];
}
