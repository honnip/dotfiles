let
  configuration = builtins.toFile "prometheus.yml" ''
    scrape_configs:
    - job_name: blocky
      stream_parse: true
      static_configs:
      - targets:
        - localhost:4000/metrics
    - job_name: node-exporter
      stream_parse: true
      static_configs:
      - targets:
        - localhost:9100
  '';
in
{
  services.victoriametrics = {
    enable = true;
    extraOptions = [ "-promscrape.config=${configuration}" ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
      };
    };
    provision.datasources.settings.datasources = [
      {
        name = "victoria-metric";
        url = "http://localhost:8428";
        type = "prometheus";
      }
    ];
  };
}
