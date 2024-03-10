{ lib, pkgs, ... }: {
  i18n.defaultLocale = lib.mkDefault "ko_KR.UTF-8";
  time.timeZone = lib.mkDefault "Asia/Seoul";
}
