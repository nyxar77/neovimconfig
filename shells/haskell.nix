{pkgs}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    haskell
    haskell-language-server
  ];
}
