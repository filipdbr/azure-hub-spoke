#!/bin/bash

apt-get update

# set up a web server
apt-get install -y nginx
echo "<h1>You're currently connected to server: $HOSTNAME</h1>" > /var/www/html/index.html

# start the service
systemctl enable nginx
systemctl start nginx 