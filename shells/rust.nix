{
  pkgs,
  inputs,
  ...
}:
pkgs.mkCustomShellNoCC {
  packages = [
    (inputs.fenix.packages.x86_64-linux.stable.withComponents [
      "rustc"
      "cargo"
      "clippy"
      "rustfmt"
      "rust-src"
    ])
    inputs.fenix.packages.x86_64-linux.stable.rust-analyzer
    pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
  ];
}
