{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    python312
    isort
    black
  ];
}
