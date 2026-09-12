# Neovim Configuration

My Neovim 0.12 configuration, managed with Home Manager.

![Dashboard](showcase/dashboard.png)
![Editor](showcase/preview.png)

## Checks

```bash
nix flake check
./scripts/check
./scripts/benchmark
```

CI runs the same checks on pushes and pull requests. A weekly job checks dependencies and upstream projects.
