LINK=$(curl -s -L https://www.python.org/downloads/ | grep 'python/3.12' | grep tar | head -1 | awk -F '"' '{print $4}')
FILE=$(echo $LINK | awk -F / '{print $NF}')
DIR=$(echo $FILE | sed -e 's/.tar.xz//')
cd /tmp
cd /tmp/Python*
curl -L -O $LINK
tar -xf $FILE && rm -f $FILE
cd $DIR
ls -l
