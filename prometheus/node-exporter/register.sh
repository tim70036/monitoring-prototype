
# Register service to systemd
chmod +x ./prometheus-node-exporter.service
sudo cp ./prometheus-node-exporter.service /etc/systemd/system

# Download node exporter first.
# Move node exporter to target folder, so service can run it.
sudo mv ./node_exporter /usr/local/bin/node_exporter
