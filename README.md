# NixOS configuration

This repository is the NixOS configuration for my machines.
The flake pins all inputs in `flake.lock`.
home-manager runs as a NixOS module, so one `nixos-rebuild` builds the system and the user environment together.
sops-nix decrypts the secrets at activation time.

## Hosts

- `acrux`: x86_64 desktop. GNOME, PipeWire, printing, and an AMD CPU and GPU.
- `antares`: aarch64 server on Oracle Cloud Ampere A1 in Osaka. It runs Caddy, FreshRSS, Vaultwarden, hister, Hermes, and Hindsight.
- `canopus`: aarch64 server on Oracle Cloud Ampere A1 in Osaka. It has one core and runs AdGuard Home.

The two servers are Tailscale exit nodes.
`acrux` and `antares` run Syncthing.

## Repository layout

- `hosts/<host>/`: the configuration of one machine. It contains the hardware configuration, the disko disk layout, the secrets file, and the services of the host.
- `hosts/modules/`: NixOS modules that all hosts share. Examples are the global settings, the user account, and Tailscale.
- `home/honnip/`: home-manager configuration. Each host imports one entry file, and that file imports the shared modules in `home/honnip/modules/`.
- `modules/`: the `nixosModules` and `homeManagerModules` outputs of the flake.
- `pkgs/`: packages that this flake adds. Examples are the GNOME themes and the skill packages for AI agents.
- `overlays/`: exposes `pkgs/` as the `additions` overlay.

## Install

Run these steps from a NixOS installer.
You need a clone of this repository or network access to GitHub.

Partition and format the disk with disko.

```shell
# partitioning
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/<host>/disko.nix
```

Install the system.

```shell
# install
nixos-install --root /mnt --flake github:honnip/dotfiles#<host>
```

## Secrets

sops-nix decrypts each secret with an age key at activation time.
Each host has one age key and its own file `hosts/<host>/secrets.yaml`.
The file `hosts/modules/secrets.yaml` is shared by all hosts.

After the first boot, add the age key of the new host to `.sops.yaml`.
Then run these commands on the host.

```shell
# secrets
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt
sops updatekeys hosts/modules/secrets.yaml
cp /etc/ssh/ssh_host_ed25519_key.pub hosts/<host>/
```

To edit a secrets file, run `sops hosts/<host>/secrets.yaml`.
This needs the PGP key of `honnip`.

## Update a host

From a clone of this repository, run `sudo nixos-rebuild switch --flake .#<host>` on the host.

## Continuous integration

The workflow `check.yml` runs `nix flake check` on each pull request and on each push to `main`.
It evaluates the packages and the system build of every host.
It does not build or deploy anything.
