{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    asm-lsp
    nasm
    binutils
  ];
}
