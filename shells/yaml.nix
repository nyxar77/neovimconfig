{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    yaml-language-server
    yamlfmt
    yamllint
    helm-ls
  ];
}
