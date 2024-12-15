{ lib, config, ... }:
let
  filterByName = name: lib.filterAttrs (_: v: lib.elem name v.devices);
  hostname = config.networking.hostName;
in
{
  services.syncthing = {
    enable = true;
    user = "honnip"; # 🤔
    group = "users";
    key = config.sops.secrets.syncthing-key.path;
    cert = config.sops.secrets.syncthing-cert.path;
    settings = {
      devices = {
        "acrux" = {
          id = "MHPYJ3U-4HTIVWC-UIYZ7OX-TY22USW-5HJN3TI-L23BA7B-BXHOOHM-NUGEGQL";
        };
        "antares" = {
          id = "BAFKS2L-GRQUYEN-6IA2UOC-OLDCC7Z-WS5GERX-JZ37LAH-OMZ7DWM-AHUZTAW";
        };
        "s23" = {
          id = "574VYXD-LVW64J3-RWWDHVO-G6FVGNE-RGFPGI6-LWDMZFW-XGV3FL3-ND7LNQK";
        };
      };
      folders = (
        filterByName hostname {
          "Obsidian" = {
            path = "~/Documents/Obsidian";
            devices = [
              "acrux"
              "antares"
              "s23"
            ];
          };
          "Music" = {
            path = "~/Music";
            devices = [
              "acrux"
              "s23"
            ];
          };
          "Stickers" = {
            path = "~/Pictures/Stickers";
            devices = [
              "acrux"
              "antares"
              "s23"
            ];
          };
        }
      );
    };
  };

  sops.secrets = {
    syncthing-key.sopsFile = ../${hostname}/secrets.yaml;
    syncthing-cert.sopsFile = ../${hostname}/secrets.yaml;
  };
}
