{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    haskell
    haskell-language-server
  ];
}
