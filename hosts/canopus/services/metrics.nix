{
  services.victorialogs.enable = true;
  services.victoriametrics = {
    enable = true;
    prometheusConfig = {
      scrape_configs = [
        {
          job_name = "node-exporter";
          static_configs = [
            {
              targets = [
                "localhost:9100"
                "antares:9100"
                "acrux:9100"
              ];
              labels.type = "node";
            }
          ];
        }
      ];
    };
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 4000;
      };
      "auth.anonymous".enabled = true;
    };
    provision.datasources.settings.datasources = [
      {
        name = "victoria";
        url = "http://localhost:8428";
        type = "prometheus";
      }
    ];
  };
}
