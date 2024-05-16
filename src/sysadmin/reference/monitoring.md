# Monitoring

## Introduction { #monitoring } 

DHIS2 can export [Prometheus](https://prometheus.io/) compatible metrics for monitoring DHIS2 nodes.

This section describes the steps required to install Prometheus and [Grafana](https://grafana.com/) using a standard installation procedure (`apt-get`) and Docker and configure Grafana to show DHIS2 metrics.

For a list of the metrics exposed by a DHIS2 instance, please refer to the monitoring guide on [GitHub](https://github.com/dhis2/wow-backend/blob/master/guides/monitoring.md).

## Setup { #monitoring_setup } 

The next sections describe how to set up Prometheus and Grafana and how to set up Prometheus to pull data from one or more DHIS2 instances.

### Installing Prometheus + Grafana on Ubuntu and Debian { #prometheus } 

- Download Prometheus from the official [download](https://prometheus.io/download/) page.

- Make sure to filter for your operating system and your CPU architecture (Linux and amd64).

- Make sure to select the latest stable version, and not the “rc” one, as it is not considered stable enough for now.

- Download the archive, either by clicking on the link or using `wget`.

```
wget https://github.com/prometheus/prometheus/releases/download/v2.15.2/prometheus-2.15.2.linux-amd64.tar.gz
```

- Untar the zip 

```
tar xvzf prometheus-2.15.2.linux-amd64.tar.gz
```

The archive contains many important files, but here is the main ones you need to know.

- `prometheus.yml`: the configuration file for Prometheus. This is the file that you are going to modify in order to tweak your Prometheus server, for example to change the scraping interval or to configure custom alerts;
- `prometheus`: the binary for your Prometheus server. This is the command that you are going to execute to launch a Prometheus instance on your Linux box;
- `promtool`: this is a command that you can run to verify your Prometheus configuration.

### Configuring Prometheus as a service { #prometheus_service } 

- Create a `Prometheus` user with a `Prometheus` group.

```
useradd -rs /bin/false prometheus
```

- Move the Prometheus binaries to the local bin directory

```
cd prometheus-2.15.2.linux-amd64/ 
cp prometheus promtool /usr/local/bin
chown prometheus:prometheus /usr/local/bin/prometheus
```

- Create a folder in the `/etc` folder for Prometheus and move the console files, console libraries and the prometheus configuration file to this newly created folder.

```
mkdir /etc/prometheus
cp -R consoles/ console_libraries/ prometheus.yml /etc/prometheus
```

Create a data folder at the root directory, with a prometheus folder inside.

```
mkdir -p /data/prometheus
chown -R prometheus:prometheus /data/prometheus /etc/prometheus/*
```

### Create a Prometheus service { #prometheus_create_service } 

To create a Prometheus _systemd_ service, head over to the `/lib/systemd/system` folder and create a new systemd file named `prometheus.service`.

```
cd /lib/systemd/system
touch prometheus.service
```

- Edit the newly created file, and paste the following content inside:

```properties
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path="/data/prometheus" \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-admin-api

Restart=always

[Install]
WantedBy=multi-user.target
```

- Save the file and enable the Prometheus service at startup

```
systemctl enable prometheus
systemctl start prometheus
```

- Test that the service is running

```
systemctl status prometheus

...
Active: active (running)
```

- It should be now possible to access the Prometheus UI by accessing `http://localhost:9090`.


### Set-up Nginx reverse proxy { #prometheus_nginx } 

Prometheus does not natively support authentication or TLS encryption. If Prometheus has to be exposed outside the boundaries of the local network, it is important to enable authentication and TLS encryption. The following steps show how to use Nginx as a reverse proxy.

- Install Nginx, if not already installed

```
apt update
apt-get install nginx
```

By default, Nginx will start listening for HTTP requests in the default `http` port, which is `80`.

If there is already an Nginx instance running on the machine and you are unsure on which port it is listening on, run the following command:

```
> lsof | grep LISTEN | grep nginx

nginx   15792   root   8u   IPv4   1140223421   0t0   TCP *:http (LISTEN)
```

The last column shows the port used by Nginx (`http` -> `80`).

By default, Nginx configuration is located in `/etc/nginx/nginx.conf`

Make sure that `nginx.conf` contains the `Virtual Host Config` section

```
##
# Virtual Host Configs
##

include /etc/nginx/conf.d/*.conf;
include /etc/nginx/sites-enabled/*;

```

- Create a new file in `/etc/nginx/conf.d` called `prometheus.conf`

```
touch /etc/nginx/conf.d/prometheus.conf
```

- Edit the newly created file, and paste the following content inside:

```
server {
  listen 1234;

  location / {
    proxy_pass           http://localhost:9090/;
  }
}
```

- Restart Nginx  and browse to http://localhost:1234

```
systemctl restart nginx

# in case of start-up errors
journalctl -f -u nginx.service
```

- Configure Prometheus for reverse proxying, by editing `/lib/systemd/system/prometheus.service` and add the following argument to the list of arguments passed to the Prometheus executable.

```
--web.external-url=https://localhost:1234
```

- Restart the service

```
systemctl daemon-reload
systemctl restart prometheus


# in case of errors
journalctl -f -u prometheus.service
```

### Enable reverse proxy authentication { #prometheus_auth } 

This section shows how to configure basic authentication via the reverse proxy. If you need a different authentication mechanism (SSO, etc.) please check the relevant documentation.

- Make sure that `htpasswd` is installed on the system

```
apt-get install apache2-utils
```

- Create an authentication file

```
cd /etc/prometheus
htpasswd -c .credentials admin 
```

Choose a strong password, and make sure that the pass file was correctly created.

- Edit the previously created Nginx configuration file (`/etc/nginx/conf.d/prometheus.conf`), and add the authentication information.

```
server {
  listen 1234;

  location / {
    auth_basic           "Prometheus";
    auth_basic_user_file /etc/prometheus/.credentials;
    proxy_pass           http://localhost:9090/;
  }
}
```

- Restart Nginx

```
systemctl restart nginx

# in case of errors
journalctl -f -u nginx.service
```

- `http://localhost:1234` should now prompt for username and password.

### Installing Grafana on Ubuntu and Debian { #grafana } 

- Add a `gpg` key and install the OSS Grafana package from APT repo

```sh
apt-get install -y apt-transport-https

wget -q -O - "https://packages.grafana.com/gpg.key" | sudo apt-key add -

add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

apt-get update

apt-get install grafana
```

- If the system is using `systemd`, a new `grafana-service` is automatically created. Check the `systemd` file to gain some insight on the Grafana installation

```
cat /usr/lib/systemd/system/grafana-server.service
```

This file is quite important because it offers information about the newly installed Grafana instance.

The file shows:

The **Grafana server binary** is located at `/usr/sbin/grafana-server`.
The file that defines all the **environment variables** is located at `/etc/default/grafana-server`
The **configuration file** is given via the `CONF_FILE` environment variable.
The **PID of the file** is also determined by the `PID_FILE_DIR` environment variable.
**Logging**, **data**, **plugins** and **provisioning** paths are given by environment variables.

- Start the server

```
systemctl start grafana-server
```

- Access Grafana web console: http://localhost:3000

The default login for Grafana is `admin` and the default password is also `admin`.
You will be prompted to change the password on first access.

- Configure Prometheus as a Grafana datasource

Access to the datasources panel by clicking on `Configuration` > `Data sources` via the left menu.

Click on `Add a datasource`

Select a Prometheus data source on the next window.

Configure the datasource according to the Prometheus setup (use authentication, TSL, etc.)

### Installing Prometheus + Grafana using Docker { #prometheus_grafana_docker } 

This section describes how to start-up a Prometheus stack containing Prometheus and Grafana.

The configuration is based on this project: https://github.com/vegasbrianc/prometheus

- Clone this Github project: https://github.com/vegasbrianc/prometheus

- Start the Prometheus stack using:

```
docker stack deploy -c docker-stack.yml prom
```

The above command, may result in the following error:

*This node is not a swarm manager. Use "docker swarm init" or "docker swarm join" to connect this node to swarm and try again*

If that happens, you need to start Swarm. You can use the following command line:

```
docker swarm init --advertise-addr <YOUR_IP>
```

Once this command runs successfully, you should be able to run the previous command without problems.

The stack contains also a Node exporter for Docker monitoring. If you are not interested in Docker monitoring, you can comment out the relevant sections in the `docker-stack.yml` file:

- `node-exporter`
- `cadvisor`

- To stop the Prometheus stack:

```
docker stack rm prom
```

The Prometheus configuration (`prometheus.yml`) file is located in the `prometheus` folder.

- Access Grafana web console at: http://localhost:3000 with username: `admin` and password: `foobar`

### Configure Prometheus to pull metrics from one or more DHIS2 instances { #prometheus_dhis2 } 

Prior to using Prometheus, it needs basic configuring. Thus, we need to create a configuration file named `prometheus.yml`

> **Note**
>
> The configuration file of Prometheus is written in YAML which strictly forbids to use tabs. If your file is incorrectly formatted, Prometheus will not start. Be careful when you edit it.

Prometheus’ configuration file is divided into three parts: `global`, `rule_files`, and `scrape_configs`.

In the global part we can find the general configuration of Prometheus: `scrape_interval` defines how often Prometheus scrapes targets, `evaluation_interval` controls how often the software will evaluate rules. Rules are used to create new time series and for the generation of alerts.

The `rule_files` block contains information of the location of any rules we want the Prometheus server to load.

The last block of the configuration file is named `scape_configs` and contains the information which resources Prometheus monitors.

A simple DHIS2 Prometheus monitoring file looks like this example:

```yaml
global:
  scrape_interval:     15s
  evaluation_interval: 15s 

scrape_configs:
  - job_name: 'dhis2'
    metrics_path: '/api/metrics'
    basic_auth:
      username: admin
      password: district
    static_configs:
      - targets: ['localhost:80']
```

The global `scrape_interval` is set to 15 seconds which is enough for most use cases.

In the `scrape_configs` part we have defined the DHIS2 exporter.
The `basic_auth` blocks contains the credentials required to access the `metrics` API: consider creating an ad-hoc user only for accessing the `metrics` endpoint.

Prometheus may or may not run on the same server as DHIS2: in the above configuration, it is assumed that Prometheus monitors only one DHIS2 instance, running on the same server as Prometheus, so we use `localhost`.

### Configure the DHIS2 exporter { #dhis2_metrics_conf } 

The monitoring subsystem is disabled by default in DHIS2.

Each metrics cluster has to be explicitly enabled in order for the metrics to be exported. To configure DHIS2 to export one or more metrics, check this [document](https://github.com/dhis2/wow-backend/blob/master/guides/monitoring.md#dhis2-monitoring-configuration).

