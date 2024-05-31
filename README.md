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
