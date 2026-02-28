{
  self,
  pkgs,
  system,
  ...
}:
pkgs.mkCustomShellNoCC {
  buildInputs = [
    self.devShells.${system}.js
    self.devShells.${system}.ts
    self.devShells.${system}.jsweb
  ];
}
