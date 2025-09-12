{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    php
    php84Packages.composer
    intelephense
  ];
}
