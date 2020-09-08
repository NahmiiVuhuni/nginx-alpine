FROM alpine:3.12.0

LABEL Maintainer="Hubok <docker-maint@hubok.net>" \
      Description="Nginx container on Alpine, compiled from source with nginx-dav-ext-module."

ENV VERSION_NGINX           1.19.2
ENV VERSION_NAXSI           0.56
ENV VERSION_DAV_EXT_MODULE  v3.0.0

COPY src /

WORKDIR /root/build/nginx

RUN apk -U upgrade \
 && apk add --no-cache gzip pcre zlib perl openssl libxslt gd geoip libaio \
 && apk add --no-cache --virtual .build gnupg wget g++ gcc6 pcre-dev zlib-dev perl-dev make openssl-dev libxslt-dev gd-dev geoip-dev libaio-dev linux-headers \
 && addgroup -g 101 -S nginx \
 && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
 && gpg --import /root/build/0x520A9993A1C052F8.key \
 && gpg --import /root/build/0x251A28DE2685AED4.key \
 && wget https://nginx.org/download/nginx-${VERSION_NGINX}.tar.gz -O /root/build/nginx.tar.gz \
 && wget https://nginx.org/download/nginx-${VERSION_NGINX}.tar.gz.asc -O /root/build/nginx.tar.gz.asc \
 && wget https://github.com/nbs-system/naxsi/archive/${VERSION_NAXSI}.tar.gz -O /root/build/naxsi.tar.gz \
 && wget https://github.com/nbs-system/naxsi/releases/download/${VERSION_NAXSI}/naxsi-${VERSION_NAXSI}.tar.gz.asc -O /root/build/naxsi.tar.gz.asc \
 && wget https://github.com/arut/nginx-dav-ext-module/archive/${VERSION_DAV_EXT_MODULE}.zip -O /root/build/nginx-dav-ext.zip \
 && printf "trusted-key 520A9993A1C052F8\ntrusted-key 251A28DE2685AED4" > /root/.gnupg/gpg.conf \
 && gpg --verify /root/build/nginx.tar.gz.asc \
 && gpg --verify /root/build/naxsi.tar.gz.asc \
 && tar -xvzf /root/build/nginx.tar.gz -C /root/build/nginx --strip-components=1 \
 && tar -xvzf /root/build/naxsi.tar.gz -C /root/build/nginx/naxsi --strip-components=1 \
 && unzip /root/build/nginx-dav-ext.zip -d /root/build/nginx/nginx-dav-ext -j \
 && /root/build/nginx/configure \
 --prefix=/usr/share/nginx \
 --pid-path=/var/pid/nginx.pid \
 --sbin-path=/usr/sbin/nginx \
 --conf-path=/etc/nginx/nginx.conf \
 --http-log-path=/var/log/nginx/access.log \
 --error-log-path=/var/log/nginx/error.log \
 --with-perl_modules_path=/etc/nginx/perl-modules \
 --user=nginx \
 --group=nginx \
 --with-threads \
 --with-file-aio \
 --with-http_addition_module \
 --with-http_auth_request_module \
 --with-http_dav_module \
 --with-http_degradation_module \
 --with-http_flv_module \
 --with-http_gunzip_module \
 --with-http_gzip_static_module \
 --with-http_image_filter_module \
 --with-http_mp4_module \
 --with-http_random_index_module \
 --with-http_realip_module \
 --with-http_secure_link_module \
 --with-http_slice_module \
 --with-http_ssl_module \
 --with-http_stub_status_module \
 --with-http_sub_module \
 --with-http_v2_module \
 --with-poll_module \
 --with-select_module \
 --with-mail_ssl_module \
 --with-stream_ssl_module \
 --with-mail=dynamic \
 --with-stream=dynamic \
 --with-http_geoip_module=dynamic \
 --with-http_image_filter_module=dynamic \
 --with-http_perl_module=dynamic \
 --with-http_xslt_module=dynamic \
 --add-dynamic-module=naxsi/naxsi_src \
 --add-dynamic-module=nginx-dav-ext \
 && make CC=gcc-6 \
 && make install \
 && apk del --no-cache .build \
 && rm -rf /root/build /root/.gnupg /tmp/*

EXPOSE 80
EXPOSE 443

WORKDIR /etc/nginx

STOPSIGNAL SIGTERM

HEALTHCHECK --interval=5m --timeout=3s CMD curl --fail http://127.0.0.1:80 || exit 1

CMD ["nginx", "-g", "daemon off;"]

