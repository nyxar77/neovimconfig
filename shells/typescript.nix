{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    typescript
    typescript-language-server
  ];
}
