{pkgs}:
pkgs.mkCustomShellNoCC {
  buildInputs = with pkgs; [
    lua-language-server
    stylua
    luajit
    lua5_1
  ];
}
