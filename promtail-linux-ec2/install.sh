# Download promtail first.
# Move it to target folder, so service can run it.
DIR=/usr/local/bin/promtail
sudo mkdir $DIR

chmod +x ./promtail-linux-amd64
sudo mv ./promtail-linux-amd64 $DIR/promtail-linux-amd64
sudo mv ./promtail.yml $DIR/promtail.yml

# Manually set up required enviroment variables in .env file in target folder...
# AWS_ACCESS_KEY_ID: crendentials for aws.
# AWS_SECRET_ACCESS_KEY: crendentials for aws.
# AWS_REGION: the region where machine is in.
# AWS_ROLE_ARN: role arn for ec2 discovery.
# ENVIRONMENT: label for log, depends on which environment the machine is in (EX: development, staging, production).
sudo touch $DIR/.env

# Register service to systemd
chmod +x ./promtail.service
sudo mv ./promtail.service /etc/systemd/system

# Let’s reload the systemd, enable then start the service:
sudo systemctl daemon-reload
sudo systemctl start promtail.service
sudo systemctl enable promtail.service
sudo systemctl status promtail.service

# If you want to see log, you can use `journalctl -u promtail.service`

# Note:
# Configure pm2 logrotate to compress rotated log to zip (set compress: true).
# So that promtail will not view rotated log as new log.
