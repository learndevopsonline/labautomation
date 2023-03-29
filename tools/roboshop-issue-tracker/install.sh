source /tmp/labautomation/dry/common-functions.sh

set -x
## Frontend
PrintCenter "RoboShop Project Setup Issue Finder"

echo This script runs only on the frontend server. Other servers it will always fail.
chatgpt_print Checking Frontend!!

chatgpt_print FRONTEND: Checking if the nginx is installed

command_print "yum list installed | grep nginx.x"






