{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    texlab
    texlivePackages.latexmk
    texlivePackages.scheme-full
  ];
}
