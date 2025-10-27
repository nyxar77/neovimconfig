{
  pkgs,
  unstablePkgs,
}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs;
    [
      # lua-language-server
      stylua
      luajit
    ]
    ++ [
      unstablePkgs.emmylua-ls
      unstablePkgs.emmylua-check
      unstablePkgs.emmylua-doc-cli
    ];
  shellHook = ''
    export PATH=$PATH:${pkgs.luajit}/bin
  '';
}
