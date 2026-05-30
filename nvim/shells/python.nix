{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    python313
    isort
    black
    # pyright
    basedpyright
  ];
}
