{ config, pkgs, lib, options, ... }:
{
  options = {
    localGrafana = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "enable local grafana";
      };
      port = lib.mkOption {
        default = 3000;
        type = lib.types.int;
        description = "port";
      };
      promPort = lib.mkOption {
        default = 9090;
        type = lib.types.int;
        description = "prometheus port";
      };
      promNodePort = lib.mkOption {
        default = 9100;
        type = lib.types.int;
        description = "prometheus node scraper port";
      };
    };
  };

  config = let
    gcfg = config.localGrafana;
  in lib.mkIf gcfg.enable {
    # Enable Prometheus server and node exporter for system metrics
    services.prometheus = {
      enable = true;
      port = gcfg.promPort;
      globalConfig.scrape_interval = "10s";
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [{
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }];
        }
      ];
      exporters.node = {
        enable = true;
        port = gcfg.promNodePort;
        listenAddress = "127.0.0.1";
      };
    };

    # Enable Grafana web dashboard
    services.grafana = {
      enable = true;
      # Optional: Configure the domain/port, default is usually localhost:3000
      # services.grafana.domain = "grafana.local";
      settings = {
        server = {
          http_port = gcfg.port;
        };
        security.secret_key = "93e2dde3c4cc07d28b220aed8a83f6fe79f442a72e2b16403c5171641ade2a35";
      };
    };

    # Ensure Grafana can access the Prometheus data source
    services.grafana.provision.datasources.settings.datasources = [
      {
        name = "Prometheus";
        type = "prometheus";
        url = "http://localhost:${toString gcfg.promPort}"; # Default Prometheus URL
        isDefault = true;
      }
    ];

    # Open the port in the firewall if accessing from other machines
    # networking.firewall.allowedTCPPorts = [ 3000 ];
  };
}
