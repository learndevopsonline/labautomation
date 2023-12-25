#LINK=$(curl -s -L https://www.python.org/downloads/ | grep 'python/3.12' | grep tar | head -1 | awk -F '"' '{print $4}')
#FILE=$(echo $LINK | awk -F / '{print $NF}')
#DIR=$(echo $FILE | sed -e 's/.tar.xz//')
#cd /tmp
#cd /tmp/Python*
#curl -L -O $LINK
#tar -xf $FILE && rm -f $FILE
#cd $DIR
#ls -l
cd /opt
curl -L  https://labautomation-s3.s3.ap-south-1.amazonaws.com/python-3.12.tar.gz  | tar -x
rm -f /bin/python &>/dev/null
ln -s /opt/python/bin/python3 /bin/python

