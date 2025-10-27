{pkgs,...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    clang-tools
    # lldb
    gcc
    gdb
    cmake
    cmake-lint
  ];
}
