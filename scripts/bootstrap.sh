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
# This script requires curl, java, and firefox be installed first. Please see
# https://github.com/delphian/behat-mink-installer/wiki for further details.
# Submit questions to https://github.com/delphian/behat-mink-installer/issues
#

# Demand that requirements are met.
CURL=`command -v curl`
if [ -z $CURL ]; then
  echo 'Curl not found. Please install curl first.'
  exit 1
fi
JAVA=`command -v java`
if [ -z $JAVA ]; then
  echo 'Java not found. Please install java runtime first.'
  exit 1
fi

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

# Look for GNU sed. gsed is used on MAC OSX. This is because MAC OSX sed does
# not operate the same as GNU sed and will reject some parameters.
SED=`command -v gsed`
if [ -z $SED ]; then
  SED="sed"
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

# Create sample feature.
if [ $WEBSITE == "http://www.google.com" ]; then
  echo '
  Feature: Test out new installation of behat and mink.
    In order to display the power of behat and mink
    As a user who just installed from bash
    I want to examine the default google site

    @javascript
    Scenario: Viewing the google site
      Given I am on the homepage
      Then I should see "google"
  ' >> features/example.feature
fi

# Include MinkContext class after second semicolon.
LINE=`grep -n ";" features/bootstrap/FeatureContext.php | cut -f1 -d: | head -2 | tail -1`
LINE=$(( $LINE+1 ))
$SED -i -e "${LINE}i use Behat\\\MinkExtension\\\Context\\\MinkContext;" features/bootstrap/FeatureContext.php
# Modify the default class to extend mink instead of behat.
$SED -i -e "s/FeatureContext extends BehatContext/FeatureContext extends MinkContext/g" features/bootstrap/FeatureContext.php

# Download the selenium server.
# Execute this server with the following command:
#
# java -jar selenium-server.jar
#
# This server must always be running in the background for
# behat to operate with mink. It's recommended that you start
# the selenium server in it's own seperate shell.
curl -o $DESTINATION/selenium-server.jar http://selenium.googlecode.com/files/selenium-server-standalone-2.31.0.jar

# Go ahead and run the server in the background
java -jar $DESTINATION/selenium-server.jar &

# Remove the installer script.
rm ../bootstrap.sh

# Wait for selenium to boot up.
sleep 10s

# Run behat test.
behat.phar
