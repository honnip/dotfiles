{ pkgs, lib, ... }:
{
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = lib.getExe pkgs.appimage-run;
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
