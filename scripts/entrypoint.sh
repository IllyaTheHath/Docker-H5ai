#!/bin/sh
if [ ! -d /www/_h5ai ]; then
    echo "Copying h5ai files... "
    unzip -q /var/h5ai.zip -d /www/
    chown -R nginx:nginx /www/*
fi
if [ -e /etc/nginx/conf.d/default.conf ]; then
    echo "Config nginx"
    rm /etc/nginx/conf.d/default.conf
fi
if [ ! -e /etc/filebrowser/filebrowser.db ]; then
    echo "Config filebrowser"
    filebrowser config init -d /etc/filebrowser/filebrowser.db
    filebrowser config set -b "/manage" -d /etc/filebrowser/filebrowser.db
    filebrowser users add admin admin --perm.admin -d /etc/filebrowser/filebrowser.db
    filebrowser rules add "/_h5ai" -d /etc/filebrowser/filebrowser.db
    filebrowser rules add -r "regex [\\\/]\..+" -d /etc/filebrowser/filebrowser.db
fi
echo "Starting services..."
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf -n