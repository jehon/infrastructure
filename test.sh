set -o errexit

./bin/jh-infrastructure setup dev

cat <<EOS | ssh root@localhost

systemctl restart grafana-agent.service || true
journalctl -f -u grafana-agent.service

EOS