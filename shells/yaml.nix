{pkgs}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    yaml-language-server
    yamlfmt
    yamllint
    helm-ls
  ];
}
