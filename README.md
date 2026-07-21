# nixos

My personal NixOS configuration, built with [flakes](https://nixos.wiki/wiki/Flakes), [home-manager](https://github.com/nix-community/home-manager), and the [Den](https://den.denful.dev) framework, based on the [default](https://den.denful.dev/tutorials/default/) template.

The primary goal of this repository is **reproducibility, extensibility, and long-term maintainability** across multiple personal hosts. It is **not intended to be a generic public template**, although its structure makes it easy for anyone to fork and adapt to their own needs.

## Table of contents

- [nixos](#nixos)
  - [Table of contents](#table-of-contents)
  - [Hosts](#hosts)
  - [Installation](#installation)
    - [Option A — Clean install](#option-a--clean-install)
    - [Option B — Adding this config to an existing NixOS install](#option-b--adding-this-config-to-an-existing-nixos-install)
  - [Quick usage](#quick-usage)
  - [Project structure](#project-structure)
  - [Den concepts](#den-concepts)
  - [Conventions used in this repository](#conventions-used-in-this-repository)
  - [Common workflows](#common-workflows)
    - [Applying changes](#applying-changes)
    - [Adding a new user](#adding-a-new-user)
    - [Adding a new host](#adding-a-new-host)
    - [Adding a new aspect](#adding-a-new-aspect)
    - [Adding a new flake input](#adding-a-new-flake-input)
    - [Testing in a VM before applying on real hardware](#testing-in-a-vm-before-applying-on-real-hardware)
  - [CI](#ci)
  - [Troubleshooting](#troubleshooting)
  - [References](#references)

## Hosts

| Host      | Machine | GPU          |
| --------- | ------- | ------------ |
| `pad`     | Laptop  | AMD (amdgpu) |
| `station` | Desktop | NVIDIA       |

Primary user on both hosts: `caiocsx`.

## Installation

This repository can be installed in two different ways, depending on whether you're starting from a blank disk or already have NixOS running.

### Option A — Clean install

Follow the full step-by-step script in this Gist:

[NixOS Installation — Btrfs & dual-boot](https://gist.github.com/caiocsx/709e1a028f9c390b4aa24b45f2125f74)

It walks through, in order:

0. Connecting to the internet (skip if using Ethernet).
1. Partitioning the disk and creating the Btrfs subvolume layout (`@`, `@home`, ...).
2. Mounting the subvolumes, plus the existing EFI partition if dual-booting alongside another OS (never format an EFI partition shared with another system).
3. Cloning this repository into `/mnt/etc/nixos`, generating the hardware configuration with `nixos-generate-config --root /mnt`, and moving it into `modules/hosts/<host>/_hardware-configuration.nix`.
4. Running `nixos-install --root /mnt --flake .#<host>`, setting the primary user's password with `passwd <user>` inside `nixos-enter`, then rebooting.

> [!WARNING]
> The disk partitioning and formatting commands in the guide are destructive. Double-check device names with `lsblk` before running any `mkfs`/`cfdisk` command.

After the first reboot, log in and move the repository into your home directory — the aliases and examples throughout this README assume the config lives at `~/nixos`:

```bash
sudo mv /etc/nixos ~/nixos
sudo chown -R "$(whoami)":users ~/nixos
```

(If you'd rather keep it at `/etc/nixos`, just adjust the paths used by the aliases in `shell/zsh.nix` accordingly.)

### Option B — Adding this config to an existing NixOS install

If you already have NixOS running (installed some other way) and want to switch to this flake without reinstalling:

```bash
git clone https://github.com/caiocsx/nixos.git ~/nixos
cd ~/nixos
```

Create a new host configuration by copying one of the existing host directories (or creating a new one), then generate and place the hardware configuration into it:

```bash
sudo nixos-generate-config --show-hardware-config > modules/hosts/<host>/_hardware-configuration.nix
```

Declare the host in `hosts.nix` — see [Adding a new host](#adding-a-new-host) for details — then build and activate:

```bash
git add -A
nix run .#<host> -- switch
```

Replace `<host>` with the name of your host (for example, `pad` or `station`).

> [!NOTE]
> Nothing needs to be installed beforehand besides Nix/NixOS itself. `nix run` builds the activation application directly from the flake.

## Quick usage

After the first `switch`, the shell aliases (defined in `shell/zsh.nix`) cover the day-to-day workflow:

| Alias         | Real command                               | What it does                                             |
| ------------- | ------------------------------------------ | -------------------------------------------------------- |
| `nix-check`   | `nix flake check`                          | Validates the whole config without applying it           |
| `nix-write`   | `nix run .#write-flake`                    | Regenerates `flake.nix` from `flake-file.inputs`         |
| `nix-rebuild` | `nh os switch ~/nixos`                     | Builds and applies the configuration to the current host |
| `nix-update`  | `nix flake update --flake ~/nixos`         | Updates all flake inputs                                 |
| `nix-upgrade` | `nix flake update ... && nh os switch ...` | Updates inputs and applies right after                   |
| `nix-clean`   | `nh clean all`                             | Cleans up old generations and runs garbage collection    |

## Project structure

```
.
├── assets/
│   └── wallpapers/                # images used by the wallpaper script in rofi/awww
├── modules/
│   ├── core/                      # system fundamentals, always active on every host
│   │   ├── locale.nix             # language (mkDefault, overridable per host)
│   │   ├── nix.nix                # Nix daemon settings (gc, experimental-features...)
│   │   ├── nixpkgs.nix            # pkgs config: unfree, insecure, overlays, useGlobalPkgs
│   │   ├── packages.nix           # system utilities without their own aspect
│   │   └── time.nix               # timezone (mkDefault, overridable per host)
│   │
│   ├── desktop/                   # graphical environment
│   │   └── hyprland/              # everything coupled to the Hyprland compositor
│   │
│   ├── hosts/                     # host-specific configuration
│   │   ├── pad/
│   │   │   ├── _hardware-configuration.nix   # generated by nixos-generate-config
│   │   │   └── default.nix
│   │   └── station/
│   │       ├── _hardware-configuration.nix
│   │       └── default.nix
│   │
│   ├── programs/                  # one aspect per program
│   ├── services/                  # optional system daemons/services
│   ├── shell/
│   ├── users/
│   │   └── caiocsx.nix            # defines the user and which aspects it includes
│   │
│   ├── defaults.nix               # stateVersion, class schema, global includes
│   ├── dendritic.nix              # Den/flake-file input wiring
│   ├── hosts.nix                  # declaration of which hosts/users exist
│   ├── nh.nix                     # generates the `nix run .#<host> -- switch` apps
│   └── vm.nix                     # generates the `nix run .#vm-<host>` apps
│
├── flake.nix                      # AUTO-GENERATED — do not edit by hand
├── flake.lock
└── README.md
```

Any `.nix` file inside `modules/` is loaded automatically by `import-tree`, regardless of folder depth — there's no manual import list. Files that are **not** Den modules (e.g. hardware-configuration generated by a tool) are prefixed with `_` so this mechanism ignores them, and are imported manually wherever needed.

## Den concepts

This repository follows the **Dendritic** pattern, implemented by [Den](https://den.denful.dev): configuration is organized by **feature** (aspect), not by host. Each aspect is a function that can generate configuration for multiple Nix "classes" at once — typically `nixos` and `homeManager` — avoiding duplicating the same idea across separate files.

```nix
den.aspects.example = {
  nixos = { pkgs, ... }: { /* system config */ };
  homeManager = { pkgs, ... }: { /* user config */ };
};
```

Main concepts used in this repo:

- **Aspect** — a feature, spanning multiple classes (e.g. `den.aspects.hyprland`).
- **`includes`** — how a host or user "turns on" an aspect (`den.aspects.pad.includes = [ den.aspects.gaming ];`).
- **`provides.to-users` / `provides.to-hosts`** — how a host and a user exchange configuration without direct coupling (e.g. the `pad` host provides monitor-specific config to the user via `provides.to-users.homeManager`).
- **`den.batteries.*`** — ready-made utilities from Den itself (`define-user`, `primary-user`, `user-shell`, etc).

## Conventions used in this repository

- **`lib.mkDefault`** on personal opinion values that make sense to vary per host/fork (timezone, language) — allows simple overriding without editing the shared file.
- **`One aspect per feature, not necessarily per package`**: Programs that naturally belong together (e.g. CLI utilities) may share the same aspect, while applications with substantial configuration should have their own.

## Common workflows

### Applying changes

```bash
git add -A                        # flakes only see files tracked by git!
nix flake check                   # validate before applying
nix run .#<host> -- switch        # apply on the current host
```

Every workflow below ends with this same sequence.

### Adding a new user

1. Create `users/<user>.nix` with `den.aspects.<user>`.
2. Add `includes` with the desired aspects.
3. Add **`user`** for user account settings (password, groups, etc), and **`homeManager`** for home-manager configuration (packages, user programs, etc).
4. Don't forget to declare your user and host in `modules/hosts`, then [apply the changes](#applying-changes).

### Adding a new host

1. Create `hosts/<host>/default.nix` with `den.aspects.<host>.nixos = { ... };`.
2. Generate the hardware configuration: `nixos-generate-config --root /mnt`, copy the result into `hosts/<host>/_hardware-configuration.nix`.
3. Declare the host in `hosts.nix`: `den.hosts.x86_64-linux.<host>.users.<user> = { };`.
4. Test with `nix run .#vm-<host>` if the change involves anything risky (GPU driver, bootloader), then [apply the changes](#applying-changes).

### Adding a new aspect

1. Create the `.nix` file in the corresponding directory (`programs/`, `services/`, `desktop/`, etc).
2. Define `den.aspects.<name> = { nixos = ...; homeManager = ...; };`.
3. Include the aspect wherever it makes sense — in `users/<user>.nix` (personal use) or in `hosts/<host>/default.nix` (host-specific).
4. [Apply the changes](#applying-changes).

### Adding a new flake input

`flake.nix` is **generated automatically**, do not edit manually:

```bash
# 1. edit flake-file.inputs in modules/dendritic.nix
nix run .#write-flake                           # regenerate flake.nix
nix flake lock --update-input <input-name>      # resolve and pin the revision
git add flake.nix flake.lock modules/
nix flake check
```

### Testing in a VM before applying on real hardware

```bash
nix run .#vm-<host>
```

Recommended for high-risk changes (drivers, bootloader, Hyprland). For small, safe changes, `nix flake check` followed directly by [applying the changes](#applying-changes) is enough.

## CI

`.github/workflows/test.yml` runs `nix flake check` on every push/PR, validating that every `nixosConfigurations` evaluates without errors — without needing real hardware. This catches most typos, renamed options, and broken references before trying to apply on a real machine.

## Troubleshooting

**`error: attribute 'x' missing`**
A new file wasn't `git add`-ed. Flakes only evaluate files tracked by git.

**`error: infinite recursion encountered`** (usually citing `homeManager@something:anon-N`)
A module is re-declaring `inputs` (or another value already available via closure) as an argument of an inner function, instead of capturing it at the outer level of the file. Always capture `{ inputs, ... }:` in the outermost function and reference it by closure from there down.

**`Refusing to evaluate package '...' because it is marked as insecure`**
Add it to the `nixpkgs.config.permittedInsecurePackages` list in `core/nixpkgs.nix`.

**`nix run .#<something>` complains that the output doesn't exist**

```bash
nix flake show
```

Confirms the exact name of the available app — switch apps are named after the **hostname** (`pad`, `station`), not the username.

## References

- [Den — official documentation](https://den.denful.dev)
- [Dendrix — repository of reusable Den aspects](https://dendrix.denful.dev)
- [home-manager — manual](https://nix-community.github.io/home-manager/)
- [NixOS — manual](https://nixos.org/manual/nixos/stable/)
- [search.nixos.org](https://search.nixos.org) — package and option search (NixOS + home-manager)
