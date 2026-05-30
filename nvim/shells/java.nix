{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    vimPlugins.nvim-java
    jdt-language-server
    openjdk
  ];
}
