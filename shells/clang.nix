{pkgs}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    clang-tools
    gcc
    lldb
    cmake
    cmake-lint
  ];
}
