{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    docker-language-server
  ];
}
