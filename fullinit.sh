echo "Setting up Keys"
cd ~
ssh-keygen -f devops -t rsa -N ''
mv devops devops.pem
echo "Installing Google Cloud CLI"
curl -s https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe -o GoogleCloudSDKInstaller.exe 
./GoogleCloudSDKInstaller.exe 
echo "Installing Python"
OSVER=$(uname -m)
if [ "$OSVER" == "x86_64" ]; then 
    curl -s https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz -o Python-2.7.15.tgz
    tar -xf Python-2.7.15.tgz
    
else
    curl -s https://www.python.org/ftp/python/2.7.15/python-2.7.15.msi -o python-2.7.15.msi
    ./python-2.7.15.msi
fi
