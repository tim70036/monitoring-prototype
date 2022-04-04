
# Download node exporter first.
# Move node exporter to target folder, so service can run it.
sudo mkdir /usr/local/bin/prometheus-node-exporter
chmod +x ./node_exporter
sudo mv ./node_exporter /usr/local/bin/prometheus-node-exporter/node_exporter


# Register service to systemd
chmod +x ./prometheus-node-exporter.service
sudo mv ./prometheus-node-exporter.service /etc/systemd/system

# Let’s reload the systemd, enable then start the service:
sudo systemctl daemon-reload
sudo systemctl start prometheus-node-exporter.service
sudo systemctl enable prometheus-node-exporter.service
sudo systemctl status prometheus-node-exporter.service

# See service log using `journalctl -u prometheus-node-exporter.service`
