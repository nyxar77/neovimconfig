{
  pkgs,
  pkgs25,
  ...
}:
pkgs.mkCustomShellNoCC {
  packages = with pkgs; [
    (pkgs25.clang-tools.override
      {
        enableLibcxx = true;
      })
    # lldb
    vscode-extensions.vadimcn.vscode-lldb.adapter
    clang
    cmake
    cmake-lint
    neocmakelsp
  ];
}
