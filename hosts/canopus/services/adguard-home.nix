{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      http = {
        address = "0.0.0.0:3053";
      };
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.google/dns-query"
          "1.1.1.1"
        ];
        bootstrap_dns = [
          "1.1.1.1"
          "8.8.8.8"
          "9.9.9.9"
        ];
        enable_dnssec = true;
        use_http3_upstreams = true;
      };
      filters = [
        {
          enabled = true;
          name = "ListKR";
          url = "https://raw.githubusercontent.com/List-KR/List-KR/master/filters-share/3rd_domains.txt";
          id = 1;
        }
        {
          enabled = true;
          name = "YousList";
          url = "https://raw.githubusercontent.com/yous/YousList/master/hosts.txt";
          id = 2;
        }
        {
          enabled = true;
          name = "SmartTV";
          url = "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV-AGH.txt";
          id = 3;
        }
        {
          enabled = true;
          name = "Windows Spy Blocker";
          url = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt";
          id = 4;
        }
        {
          enabled = true;
          name = "Badware";
          url = "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt";
          id = 5;
        }
        {
          enabled = true;
          name = "Stalkerware";
          url = "https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts";
          id = 6;
        }
        {
          enabled = true;
          name = "StevenBlack's ad+malware list";
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          id = 7;
        }
        {
          enabled = true;
          name = "DandeliionSprout's malware list";
          url = "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareAdGuardHome.txt";
          id = 8;
        }
        {
          enabled = true;
          name = "malware filter";
          url = "https://malware-filter.gitlab.io/malware-filter/phishing-filter-agh.txt";
          id = 9;
        }
        {
          enabled = true;
          name = "oisd small";
          url = "https://small.oisd.nl";
          id = 10;
        }
        {
          enabled = true;
          name = "AdGuard DNS list composed of several filters";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          id = 11;
        }
      ];
      user_rules = [ "@@cdn.discordapp.com" ];
    };
  };

  services.tailscale.extraUpFlags = [ "--accept-dns=false" ];
}
