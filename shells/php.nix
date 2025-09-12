{pkgs}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    php
    php84Packages.composer
    intelephense
  ];
}
