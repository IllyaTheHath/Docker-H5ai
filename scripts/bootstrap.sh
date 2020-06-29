#!/bin/sh
echo "Apply Boostrap..."
if [ ! -d /www/public ]; then
    echo "Creating public folder... "
    mkdir -p /www/public
fi
if [ ! -d /www/private ]; then
    echo "Creating private folder... "
    mkdir -p /www/private
fi
if [ ! -d /www/public/_h5ai ]; then
    echo "Copying h5ai files... "
    unzip -q /var/h5ai.zip -d /www/public/
    chown -R nginx:nginx /www/*
fi
if [ ! -e /etc/filebrowser/filebrowser.db ]; then
    echo "Config filebrowser"
    filebrowser config init -d /etc/filebrowser/filebrowser.db
    filebrowser config set -b "/manage" -d /etc/filebrowser/filebrowser.db
    filebrowser users add admin admin --perm.admin -d /etc/filebrowser/filebrowser.db
    filebrowser rules add "/public/_h5ai" -d /etc/filebrowser/filebrowser.db
    filebrowser rules add -r "regex [\\\/]\..+" -d /etc/filebrowser/filebrowser.db
fi
echo "Done!"
echo "Starting Service"
supervisorctl start php-fpm nginx filebrowser
