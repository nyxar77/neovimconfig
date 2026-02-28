{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    tinymist
  ];
}
