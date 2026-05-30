{pkgs, ...}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    php
    php84Packages.composer
    php84Extensions.xdebug
    vscode-extensions.xdebug.php-debug
    intelephense
  ];
}
