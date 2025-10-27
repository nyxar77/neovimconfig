{pkgs,...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    bashdb
    bash-language-server
  ];
}
