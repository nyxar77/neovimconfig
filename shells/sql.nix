{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    sqls
  ];
}
