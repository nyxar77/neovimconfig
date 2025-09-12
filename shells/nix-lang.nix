{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    nixd
    alejandra
  ];
}
