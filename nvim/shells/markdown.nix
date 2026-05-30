{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    # vimPlugins.markview-nvim
    marksman
  ];
}
