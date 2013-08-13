#!/bin/bash
#
# Execute this installer by copying and pasting the following into a terminal:
#
# curl -L -o bootstrap.sh http://goo.gl/0VxD7M && chmod 744 bootstrap.sh && ./bootstrap.sh
#
# The original bootstrap file may be viewed at:
#
# https://github.com/delphian/behat-mink-installer/blob/master/scripts/bootstrap.sh
#

echo ''
echo -ne "Install php archives to directory (/usr/local/bin): "
read DESTINATION
if [ -z $DESTINATION ]; then
  DESTINATION="/usr/local/bin"
fi

echo -ne "Website (http://www.google.com): "
read WEBSITE
if [ -z $WEBSITE]; then
  WEBSITE="http://www.google.com"
fi

getsrc() {
  ( 
    cd $2 > /dev/null;
    curl -O $1;
    FILE=`echo $1 | sed 's/.*\///'`
    chmod $3 $FILE    
  )
}

# Download php archives and make behat.phar executable.
getsrc http://behat.org/downloads/behat.phar $DESTINATION 744
getsrc http://behat.org/downloads/mink.phar $DESTINATION 644
getsrc http://behat.org/downloads/mink_extension.phar $DESTINATION 644

mkdir behat
cd behat
$DESTINATION/behat.phar --init

# Generate yaml file instructing behat where to find the php archives.
echo "#behat.yml
default:
  extensions:
    $DESTINATION/mink_extension.phar:
      mink_loader: '$DESTINATION/mink.phar'
      base_url:    '$WEBSITE'
      goutte:      ~
      selenium2:   ~
" >> behat.yml

# Modify the default class to extend mink instead of behat.


# Download the selenium server.
# Execute this server with the following command:
#
# java -jar selenium-server.jar
#
# This server must always be running in the background for
# behat to operate with mink.
curl -o $DESTINATION/selenium-server.jar http://selenium.googlecode.com/files/selenium-server-standalone-2.31.0.jar

# Go ahead and run the server in the background
java -jar $DESTINATION/selenium-server.jar &

