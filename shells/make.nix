{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    checkmake
  ];
}
