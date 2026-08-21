# NixOS configuration

My NixOS configuration, tracking `nixos-unstable`, with support for [ROCm](https://github.com/ROCm/ROCm) and my [.emacs.d](https://github.com/enzuru/.emacs.d).

## Layout

```
flake.nix     one nixosConfiguration per host, via the mkHost helper
common.nix    everything both machines share
hosts/        per-machine hardware, power policy and build tuning
modules/      the shared module library, imported by common.nix
```

Hosts are named after their hostname, so each machine can rebuild itself
without naming a target. `hosts/<name>/hardware-configuration.nix` supplies
`nixpkgs.hostPlatform`, so the flake never hardcodes a system string.

| Host | Notes |
| --- | --- |
| `desktop` | Always on: suspend/hibernate disabled, `max-jobs`/`cores` pinned to 4, OBS Studio |
| `laptop` | Suspend left enabled, `max-jobs` on `auto` |

## Usage

Run all commands from the repo directory.

**Apply config changes** (targets the host matching this machine's hostname):
```sh
sudo nixos-rebuild switch --flake .
```

**Update all inputs (nixpkgs, emacs-overlay, etc.) then apply:**
```sh
nix flake update
sudo nixos-rebuild switch --flake .
```

**Update a single input:**
```sh
nix flake update emacs-overlay
sudo nixos-rebuild switch --flake .
```

**Test without switching (rolls back on reboot):**
```sh
sudo nixos-rebuild test --flake .
```

**Build without activating:**
```sh
sudo nixos-rebuild build --flake .
```

**Roll back to previous generation:**
```sh
sudo nixos-rebuild switch --rollback
```

**Check the other host still evaluates, without leaving this machine:**
```sh
nixos-rebuild build --flake .#laptop
```

**Deploy to the other host over SSH:**
```sh
nixos-rebuild switch --flake .#laptop --target-host laptop --use-remote-sudo
```

## Adding a host

1. `mkdir hosts/<name>`
2. Put its `hardware-configuration.nix` there (from `nixos-generate-config`).
3. Write `hosts/<name>/default.nix` importing it, plus that machine's
   `system.stateVersion`, swap and any power/build tuning.
4. Add `<name> = mkHost "<name>";` to `flake.nix`.

**Note:** `flake.lock` should be committed to git. If you add a new `.nix` file, run `git add` before rebuilding — the flake evaluator requires all files to be git-tracked.
