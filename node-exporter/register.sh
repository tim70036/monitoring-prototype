
# Register service to systemd
chmod +x ./prometheus-node-exporter.service
sudo cp ./prometheus-node-exporter.service /etc/systemd/system
sudo start prometheus-node-exporter.service
sudo enable prometheus-node-exporter.service
sudo status prometheus-node-exporter.service

# Download node exporter first.
# Move node exporter to target folder, so service can run it.
chmod +x ./node_exporter
sudo mv ./node_exporter /usr/local/bin/node_exporter
