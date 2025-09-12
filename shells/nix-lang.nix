{pkgs}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    nixd
    alejandra
  ];
}
