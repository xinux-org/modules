## Code formatter and checkers
```bash
nix fmt .
nix flake check --system x86_64-linux --show-trace
nix repl :lf .

# geting narHash
nix flake prefetch "github:xinux-org/modules"
# getting rev
git rev-parse main
```