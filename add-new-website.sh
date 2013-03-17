#!/bin/bash

# A script to create all the necessary files to setup a new local website
# All files are written to $HOME/www
# The script requires the user to enter the name of the new directory

# Set directory structure

SITEHOME="$HOME/www"
HOSTSFILE="/etc/hosts"
APACHE="/etc/apache2/sites-available"
SAMPLEVS="$HOME/www/virtual-server-template"
TMP="$HOME/tmp"

# Error function

error ()
{
  echo $1
  exit
}

# 0. Make sure the user entered a directory

if [ ! $1 ]
then
  error 'No directory entered. Please enter a new valid directory name.'
else
  SITENAME=$1
fi

# 1. Create the new directory

# Set directory

SITEDIR="$SITEHOME/$1"

#     Check directory doesn't already exist and create

if [ -d $SITEDIR ]
then
  error "Directory already exists."
else
  mkdir $SITEDIR
fi

# 2. Add the new directory to /etc/hosts

sudo sed -i "s/^127.0.0.1 *law.*/& $SITENAME/" $HOSTSFILE

# 3. Add a new virtual server file for apache2

TMPVS=$TMP/$SITENAME
APACHEVS=$APACHE/$SITENAME
sed "s|SITEDIRECTORY|"$SITEDIR"|" $SAMPLEVS >> $TMPVS
sudo cp $TMPVS $APACHE
rm $TMPVS

# 4. Enable the new virtual server

sudo a2ensite $SITENAME
sudo service apache2 restart
