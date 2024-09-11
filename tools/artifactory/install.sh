echo '[Artifactory]
name=Artifactory
baseurl=https://releases.jfrog.io/artifactory/artifactory-rpms/
enabled=1
gpgcheck=0
gpgkey=https://releases.jfrog.io/artifactory/artifactory-rpms/repodata/repomd.xml.key
repo_gpgcheck=0' > /etc/yum.repos.d/artifactory.repo

PACK=$(yum list all  --showduplicates| grep Artifactory | grep jfrog-artifactory-oss.x86_64 | tail -1 | awk '{print $1"-"$2}' | sed -e 's/.x86_64//')

yum install $PACK -y
systemctl enable artifactory
systemctl start artifactory
echo 'configVersion: 1
shared:
    security:
    node:
    database:
        allowNonPostgresql: true
access:' >/opt/jfrog/artifactory/var/etc/system.yaml
systemctl restart artifactory

