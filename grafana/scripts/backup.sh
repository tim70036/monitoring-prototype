docker run --rm --volumes-from monitoring-prototype_grafana_1 -v $(pwd):/backup ubuntu bash -c "tar cvf /backup/backup.tar /var/lib/grafana"
# docker run --rm --volumes-from monitoring-prototype_grafana_1 -v $(pwd):/backup ubuntu bash -c "tar xvf /backup/backup.tar"