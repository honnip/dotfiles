{ self, lib, ... }:
{
  hollo = lib.modules.importApply ./hollo.nix self;
}
