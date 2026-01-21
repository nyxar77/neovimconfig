{
  self,
  pkgs,
  system,
  ...
}:
pkgs.mkCustomShellNoCC {
  packages = [
    self.devShells.${system}.js
    self.devShells.${system}.ts
    self.devShells.${system}.jsweb
  ];
}
