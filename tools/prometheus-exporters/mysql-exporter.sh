latest_version=$(curl -s https://github.com/prometheus/mysqld_exporter/releases | grep '/releases/download/v' | sed -e 's|/| |g' | awk '{print $7}' | head -1 | sed -e 's/v//')

cd /opt
curl -s -L -O https://github.com/prometheus/mysqld_exporter/releases/download/v${latest_version}/mysqld_exporter-${latest_version}.linux-amd64.tar.gz
download_file=mysqld_exporter-${latest_version}.linux-amd64.tar.gz
dir_name=mysqld_exporter-${latest_version}.linux-amd64

## Remove existing exporter
rm -rf mysqld_exporter
tar -xf $download_file
rm -f $download_file
mv $dir_name mysqld_exporter

echo '[client]
user = exporter
password = exporter123
host = localhost' >/opt/mysqld_exporter/cnf

cp /tmp/labautomation/tools/prometheus-exporters/mysqld_exporter.service /etc/systemd/system/mysqld_exporter.service
systemctl enable mysqld_exporter
systemctl start mysqld_exporter


echo "Login to MySQL and run these mysql commands"
echo '------------------------------------------------------------------------------------------'
echo "CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'exporter' WITH MAX_USER_CONNECTIONS 3;"
echo "GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';"
echo '------------------------------------------------------------------------------------------'

