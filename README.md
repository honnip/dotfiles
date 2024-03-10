# nixos-configuration

```shell
# partitioning
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/<host>/disko.nix
```

```
# install
nixos-install --root /mnt --flake github:honnip/dotfiles#<host>
```

```
# secrets
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt
sops updatekeys hosts/modules/secrets.yaml
cp /etc/ssh/ssh_host_ed25519_key.pub hosts/<host>/
```
