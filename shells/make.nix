{pkgs}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    checkmake
  ];
}
