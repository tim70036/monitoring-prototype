# promtail-linux-ec2
## Introduction
This repo demos installing promtail onto a AWS EC2 Linux machine. We're registering promtail as a **systemd** service. The targets that promtail scrape from is an **node.js** application managed by **pm2**. Promtail basically looks for log files that contain certain prefix and push the log content to a remote **Loki** endpoint. Specifically, it includes application log, pm2 log and systemd log from a couple service.

## Prerequisites
1. Download promtail executable into this folder. You can download it from official release repo [here](https://github.com/grafana/loki/releases). You should choose `promtail-linux-amd64.zip` unless your Linux EC2 has different architecture.
2. Ensure you have your EC2 running and the application on it is runned by **pm2**.
3. Check whether the log files are produced. See `__path__` label in `promtail.yml` to know which files promtail looks for.

Remember to install and config pm2-logrotate so that the disk usage will not explode. Also, you must compress rotated log to zip (set compress: true). So that promtail will not view rotated log as new log.
```
pm2 set pm2-logrotate:compress true
pm2 set pm2-logrotate:rotateInterval '0 0 * * *'
pm2 set pm2-logrotate:max_size 200M
pm2 set pm2-logrotate:retain 5
```

## Installation
Move promtail executable to target folder, so **systemd** can find it.
```
DIR=/usr/local/bin/promtail
sudo mkdir $DIR

chmod +x ./promtail-linux-amd64
sudo mv ./promtail-linux-amd64 $DIR/promtail-linux-amd64
sudo mv ./promtail.yml $DIR/promtail.yml
```

 Manually set up enviroment variables in `.env` file in target folder. These variables enable promtail to do ec2 service discorvery and extra information for labels.
```
sudo touch $DIR/.env
# Set the following variables in the format `var=value` per line:
# LOKI_HOST: the loki host that will recieve logs.
# LOKI_PORT: the port of the loki host.
# AWS_ACCESS_KEY_ID: crendentials for aws.
# AWS_SECRET_ACCESS_KEY: crendentials for aws.
# AWS_REGION: the region where machine is in.
# AWS_ROLE_ARN: role arn for ec2 discovery.
# ENVIRONMENT: label for log, depends on which environment the machine is in (EX: development, staging, production).
```

Register service to systemd
```
chmod +x ./promtail.service
sudo mv ./promtail.service /etc/systemd/system
```

Reload the systemd, then start the service
``` 
sudo systemctl daemon-reload
sudo systemctl start promtail.service
sudo systemctl enable promtail.service
sudo systemctl status promtail.service
```

## Note
- If you want to see log, you can use `journald`. For example, `journalctl -u promtail.service`.
- You can open browser on port 9080 to see the status of promtail. (http://localhost:9080) Make sure there is no firewall rule blocking this port.