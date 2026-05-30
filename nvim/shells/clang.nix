{pkgs, ...}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    (pkgs.clang-tools.override
      {
        enableLibcxx = true;
      })
    # lldb
    vscode-extensions.vadimcn.vscode-lldb.adapter
    clang
    pkg-config
    cmake
    cmake-lint
    neocmakelsp
  ];
}
