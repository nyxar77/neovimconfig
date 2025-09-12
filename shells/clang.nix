{pkgs}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    clang-tools
    gcc
    lldb
    cmake
    cmake-lint
  ];
}
