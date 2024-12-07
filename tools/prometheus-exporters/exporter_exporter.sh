latest_version=$(curl -s https://github.com/QubitProducts/exporter_exporter/tags | grep '0.5.0' | grep '.tar.gz' | sed -e 's|/| |g' | awk '{print $9}' | sed -e 's|.tar.gz"||' -e 's/^v//')

cd /opt
curl -s -L -O https://github.com/QubitProducts/exporter_exporter/releases/download/v${latest_version}/exporter_exporter-${latest_version}.linux-amd64.tar.gz
download_file=exporter_exporter-${latest_version}.linux-amd64.tar.gz
dir_name=exporter_exporter-${latest_version}.linux-amd64

## Remove existing exporter
rm -rf exporter_exporter
tar -xf $download_file
rm -f $download_file
mv $dir_name exporter_exporter

cp /tmp/labautomation/tools/prometheus-exporters/exporter_exporter.conf /opt/exporter_exporter/exporter_exporter.conf

cp /tmp/labautomation/tools/prometheus-exporters/exporter_exporter.service /etc/systemd/system/exporter_exporter.service
systemctl enable exporter_exporter
systemctl start exporter_exporter

