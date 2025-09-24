# nix-config

My configs for both nixos and home manager only machines

## structure

```
.
├── flake.nix
├── configs
│   ├── home-manager
│   └── nixos
├── hosts
├── modules
│   ├── home-manager
│   └── hostopts.nix
├── roles
│   ├── home-manager
│   └── nixos
└── templates
```
* Configs set options and specify programs to be installed.
They do not specify their own options, and take effect as soon as they are imported.
Generally, a config will be specific to a single program, and possibly optional dependecies of the main program.
* Hosts define specific hosts. They are the entry point into the system.
Each host *must* import `configs/nixos/common.nix` in the top level and `configs/home-manager/common.nix` in the home-manager block.
Each host *must also* define the variables declared in `modules/hostopts.nix`.
* Modules are always imported by the respective common.nix. They each have an enable option, and only have effects if enabled.
* Roles are larger bundles of software and options. They define packages to be installed and may import configurations or enable modules.

## Secrets
This repo uses nix-sops for secrets management, with the encrypted secrets being stored in a private repo imported as an input.
if the `nix-secrets` input is commented out, the repo should still build, gracefully degrading to default, non-secret, values.

## Spinning up a new machine:
run `nix build ./#iso` or `nix build aarch64-iso.nix` (depending on architecture), and boot it while on the same network.
(you can also use a regular nixos iso, but this has my tools and pub ssh keys already on it.)
SSH into the machine (hostname will be nixos-installer), and run `nixos-generate --show-hardware-config`, and copy the kernel modules section into your config.
run `ls /dev/disk/by-id`, and note the disk IDs.

Now your ready to write a config.
You should probably base it off of one of the other configs in `hosts`.
Just modify it to your needs (adding roles, importing other configs, setting up networking, etc) and write a `disk-config.nix` for it.
now, run `nix run github:nix-community/nixos-anywhere -- --flake .\#$CONFIG_NAME root@nixos-installer`, and nixos anywhere will do the rest.
If the machine is headless, you probably also want to add an entry to the deploy config, to update it remotely.
