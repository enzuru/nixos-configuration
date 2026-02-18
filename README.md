# NixOS configuration

My NixOS configuration, tracking `nixos-unstable`, with support for [ROCm](https://github.com/ROCm/ROCm) and my [.emacs.d](https://github.com/enzuru/.emacs.d).

## Usage

Run all commands from the repo directory.

**Apply config changes:**
```sh
sudo nixos-rebuild switch --flake .#nixos
```

**Update all inputs (nixpkgs, emacs-overlay, etc.) then apply:**
```sh
nix flake update
sudo nixos-rebuild switch --flake .#nixos
```

**Update a single input:**
```sh
nix flake update emacs-overlay
sudo nixos-rebuild switch --flake .#nixos
```

**Test without switching (rolls back on reboot):**
```sh
sudo nixos-rebuild test --flake .#nixos
```

**Build without activating:**
```sh
sudo nixos-rebuild build --flake .#nixos
```

**Roll back to previous generation:**
```sh
sudo nixos-rebuild switch --rollback
```

**Note:** `flake.lock` should be committed to git. If you add a new `.nix` file, run `git add` before rebuilding — the flake evaluator requires all files to be git-tracked.
