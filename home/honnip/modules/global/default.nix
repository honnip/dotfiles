{ inputs, lib, pkgs, config, outputs, ... }: {
  imports = [

  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = { allowUnfree = true; };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "honnip";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05";
    sessionPath = [ "$HOME/.local/bin" ];
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
