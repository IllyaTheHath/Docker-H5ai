FROM alpine
LABEL maintainer="IllyaTheHath <kagura@chiyuki.cc>"

# ENV APK_MIRROR="dl-cdn.alpinelinux.org" \
ENV APK_MIRROR="mirrors.tuna.tsinghua.edu.cn" \
    H5AI_VERSION="0.29.2" \
    TZ="Asia/Shanghai" \
    TZ_PHP="Asia\/Shanghai"

# bootstrap
COPY scripts/bootstrap.sh /bootstrap.sh

# install nginx and php7
RUN sed -i "s/dl-cdn.alpinelinux.org/${APK_MIRROR}/g" /etc/apk/repositories \
    && apk update \
    && apk --no-cache add nginx php7-fpm php7-cli php7-json php7-phar php7-iconv php7-openssl php7-zlib php7-session php7-gd php7-exif ffmpeg imagemagick supervisor \
    && mkdir /www \
    && chown -R nginx:nginx /var/lib/nginx \
    && chown -R nginx:nginx /www \
    && mkdir -p /run/nginx \
    && rm /etc/nginx/conf.d/default.conf \
    && sed -i "s/client_max_body_size 1m/client_max_body_size 0/g" /etc/nginx/nginx.conf \
# get h5ai and filebrowser
    && apk --no-cache add curl zip unzip bash \
    && curl -o /var/h5ai.zip https://release.larsjung.de/h5ai/h5ai-${H5AI_VERSION}.zip \
    && curl -fsSL https://filebrowser.org/get.sh | bash \
    && apk del curl bash \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
# timezone
    && apk --no-cache add tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && sed -i "s/^;date\.timezone =/date\.timezone =${TZ_PHP}/g" /etc/php7/php.ini \
    && chmod +x /bootstrap.sh

# add website
COPY conf/h5ai.nginx.conf /etc/nginx/conf.d/

# supervisor
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /www
EXPOSE 80

VOLUME ["/www"]
VOLUME ["/etc/filebrowser"]

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf" ]
