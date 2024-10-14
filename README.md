
## Reload Proemtheus Configuration without Restarting
To do this, you have to first start your Prometheus process with `--web.enable-lifecycle` flag. After starting with this flag, then you can hit the below URL every time you want to reload your config changes.
```
curl -X POST <your_prometheus_server_url>:<port>/-/reload
```