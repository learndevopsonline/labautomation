URL=$(curl -s -L https://github.com/grafana/grizzly/releases | grep linux-amd64 | head -1 | awk -F '[&,;]' '{print $(NF-2)}')
curl -L -o /bin/grr $URL
chmod +x /bin/grr
