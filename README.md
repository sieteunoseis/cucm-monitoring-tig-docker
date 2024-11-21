# Cisco Unified Communications Manager Monitoring Stack (TIG Stack)

Multi-container Docker app built from the following services:

* [Telegraf](https://github.com/influxdata/telegraf) - agent for collecting, processing, aggregating, and writing snmp metrics
* [InfluxDB](https://github.com/influxdata/influxdb) - time series database
* [Grafana](https://github.com/grafana/grafana) - visualization UI for InfluxDB
* [Perfmon](https://github.com/sieteunoseis/perfmon-influx-exporter) - Cisco Perfmon Collector set to run every 15 seconds
* [Risport](https://github.com/sieteunoseis/risport-influx-exporter) -  Cisco RisPort Collector set to run every 300 seconds

Useful for quickly setting up a monitoring stack for Cisco Unified Communications Manager.

![Sample Graph](https://github.com/sieteunoseis/cucm-monitoring-tig-docker/blob/6c6abff971c746f88fa48287110c44de300310de/screenshots/grafana-cucm-system-health.png)

## Quick Start

To start the app:

1. Install [docker-compose](https://docs.docker.com/compose/install/) on the docker host.
2. Clone this repo on the docker host.
```
git clone
```
3. Copy example.env to .env and edit the file to set the environment variables.
```
cp example.env .env
```
4. Edit the .env file to set the environment variables. Additional information on the enviromental variables for Perfmon and Risport containers can be found at the following links:

* [Perfmon](https://github.com/sieteunoseis/perfmon-influx-exporter)
* [Risport](https://github.com/sieteunoseis/risport-influx-exporter)


5. Edit the **telegraf.conf** file. Replace the IP address in the **inputs.ping.urls** and **inputs.snmp.agents** section with the IP address of the CUCM server. Also update the **inputs.snmp.community** section with the SNMP community string.

6. Run the following command from the root of the cloned repo:
```
docker compose up -d
```

## Ports

The services in the app run on the following ports:

| Host Port | Service |
| - | - |
| 3000 | Grafana |
| 8086 | InfluxDB |

## Volumes

The app creates the following named volumes (one for each service) so data is not lost when the app is stopped:

* influxdb2-data
* influxdb2-config
* grafana-storage

In addition, the app maps the following directories to the host:

* ./influxdb-provisioning/scripts:/docker-entrypoint-initdb.d
* ./data:/usr/src/app/data

## Users

The app creates two admin users - one for InfluxDB and one for Grafana. By default, the username and password of both accounts is `administrator`. To override the default credentials, set the following environment variables before starting the app:

* `INFLUXDB_USERNAME`
* `INFLUXDB_PASSWORD`
* `GRAFANA_USERNAME`
* `GRAFANA_PASSWORD`

API token is also needed for InfluxDB. Free online token generator can be found [here](https://it-tools.tech/token-generator).

## Database

The app creates a default InfluxDB bucket called `cisco_perfmon`. It also uses a post install script to create two additional buckets: `telegraf` and `cisco_risport`

## Data Sources

The app creates a Grafana data source called `InfluxDB` that's connected to the default InfluxDB bucket (e.g. `cisco_perfmon`).

To provision additional data sources, see the Grafana [documentation](http://docs.grafana.org/administration/provisioning/#datasources) and add a config file to `./grafana-provisioning/datasources/` before starting the app.

## Dashboards

By default, the app does not create any Grafana dashboards. Example dashboards are located at `./grafana-provisioning/dashboards`.

Dashboards are pre-configured to use the `InfluxDB` data source and data from Perfmon and RisPort collectors.

To provision additional dashboards, see the Grafana [documentation](http://docs.grafana.org/administration/provisioning/#dashboards) and add a config file to `./grafana-provisioning/dashboards/` before starting the app.