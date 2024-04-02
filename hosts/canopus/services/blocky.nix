{
  services.blocky = {
    enable = true;
    settings = {
      upstreams.groups.default = [
        "https://dns.cloudflare.com/dns-query"
        "https://dns.google/dns-query"
        "https://dns.quad9.net/dns-query"
      ];
      bootstrapDns = [ "1.1.1.1" "9.9.9.9" ];
      blocking = {
        blackLists = {
          ads = [
            "https://big.oisd.nl/domainswild"
            "https://raw.githubusercontent.com/List-KR/List-KR/master/filters-share/3rd_domains.txt"
            "https://raw.githubusercontent.com/yous/YousList/master/hosts.txt"
            "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV-AGH.txt"
            "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
          ];
          tracker = [
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
          ];
          malicious = [
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
            "https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareAdGuardHome.txt"
            "https://malware-filter.gitlab.io/malware-filter/phishing-filter-agh.txt"
          ];
        };
        clientGroupsBlock.default = [ "ads" "tracker" "malicious" ];
      };
      prometheus.enable = true;
      httpPort = 4000;
    };
  };

  services.tailscale.extraUpFlags = [ "--accept-dns=false" ];
}
