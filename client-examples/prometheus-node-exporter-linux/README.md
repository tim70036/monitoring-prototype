# prometheus-node-exporter-linux
## Introduction
This repo demos installing prometheus node exporter onto a Linux machine. We're registering promtail as a **systemd** service. This node exporter simply collects machine level metrics and. It then listens on port `9100` to wait for some prometheus instance to come and scrape those metric data.

## Prerequisites
1. Download node-exporter executable into this folder. You can download it from official release repo [here](https://github.com/prometheus/node_exporter/releases). You should choose `linux-amd64` variant unless your Linux machine has different architecture.
2. Rename the executable to `node_exporter`.
3. Ensure your prometheus instance can access port `9100` on this machine. (No firewall rule blocking this port)

## Installation
Move promtail executable to target folder, so **systemd** can find it.
```
DIR=/usr/local/bin/prometheus-node-exporter
sudo mkdir $DIR
chmod +x ./node_exporter
sudo mv ./node_exporter $DIR/node_exporter
```

Register service to systemd
```
chmod +x ./prometheus-node-exporter.service
sudo mv ./prometheus-node-exporter.service /etc/systemd/system
```

Reload the systemd, then start the service
```
sudo systemctl daemon-reload
sudo systemctl start prometheus-node-exporter.service
sudo systemctl enable prometheus-node-exporter.service
sudo systemctl status prometheus-node-exporter.service
```
## Note
- If you want to see log, you can use `journald`. For example, `journalctl -u prometheus-node-exporter.service`.
- You can open browser on port 9100 to see the status of node exporter. (http://localhost:9100) Make sure there is no firewall rule blocking this port.
