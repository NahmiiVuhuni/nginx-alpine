FROM alpine:3.13.2

LABEL Maintainer="Hubok <docker-maint@hubok.net>" \
      Description="Nginx container on Alpine, compiled from source with naxsi and nginx-dav-ext-module."

ENV VERSION_NGINX           1.19.7
ENV VERSION_NAXSI           1.3
ENV VERSION_DAV_EXT_MODULE  3.0.0
ENV VERSION_FANCYINDEX		0.5.1

COPY src /

RUN mkdir /root/build/nginx

WORKDIR /root/build/nginx

RUN apk -U upgrade \
 && apk add --no-cache gzip pcre zlib perl openssl libxslt gd geoip curl \
 && apk add --no-cache --virtual .build linux-headers perl-dev gnupg wget g++ pcre-dev zlib-dev make openssl-dev libxslt-dev gd-dev geoip-dev \
 && addgroup -g 101 -S nginx \
 && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
 && wget https://nginx.org/download/nginx-${VERSION_NGINX}.tar.gz -O /root/build/nginx.tar.gz \
 && wget https://nginx.org/download/nginx-${VERSION_NGINX}.tar.gz.asc -O /root/build/nginx.tar.gz.asc \
 && wget https://github.com/nbs-system/naxsi/archive/${VERSION_NAXSI}.tar.gz -O /root/build/naxsi.tar.gz \
 && wget https://github.com/nbs-system/naxsi/releases/download/${VERSION_NAXSI}/naxsi-${VERSION_NAXSI}.tar.gz.asc -O /root/build/naxsi.tar.gz.asc \
 && wget https://github.com/arut/nginx-dav-ext-module/archive/v${VERSION_DAV_EXT_MODULE}.zip -O /root/build/nginx-dav-ext.zip \
 && wget https://github.com/aperezdc/ngx-fancyindex/releases/download/v${VERSION_FANCYINDEX}/ngx-fancyindex-${VERSION_FANCYINDEX}.tar.xz -O /root/build/ngx-fancyindex.tar.xz \
 && gpg --import /root/build/pgp/* \
 && printf "always-trust" > /root/.gnupg/gpg.conf \
 && gpg --verify /root/build/nginx.tar.gz.asc \
 && gpg --verify /root/build/naxsi.tar.gz.asc \
 && mkdir /root/build/nginx/naxsi /root/build/nginx/nginx-dav-ext /root/build/nginx/fancyindex \
 && tar -xvzf /root/build/nginx.tar.gz -C /root/build/nginx --strip-components=1 \
 && tar -xvzf /root/build/naxsi.tar.gz -C /root/build/nginx/naxsi --strip-components=1 \
 && tar -xf /root/build/ngx-fancyindex.tar.xz -C /root/build/nginx/fancyindex --strip-components=1 \
 && unzip /root/build/nginx-dav-ext.zip -d /root/build/nginx/nginx-dav-ext -j \
 && /root/build/nginx/configure \
 --prefix=/usr/lib/nginx \
 --sbin-path=/sbin/nginx \
 --pid-path=/var/pid/nginx \
 --conf-path=/etc/nginx/nginx.conf \
 --http-log-path=/dev/stdout \
 --error-log-path=/dev/stderr \
 --pid-path=/var/pid/nginx.pid \
 --user=nginx \
 --group=nginx \
 --with-file-aio \
 --with-pcre-jit \
 --with-threads \
 --with-poll_module \
 --with-select_module \
 --with-stream_ssl_module \
 --with-http_addition_module \
 --with-http_auth_request_module \
 --with-http_dav_module \
 --with-http_degradation_module \
 --with-http_flv_module \
 --with-http_gunzip_module \
 --with-http_gzip_static_module \
 --with-mail_ssl_module \
 --with-http_mp4_module \
 --with-http_random_index_module \
 --with-http_realip_module \
 --with-http_secure_link_module \
 --with-http_slice_module \
 --with-http_ssl_module \
 --with-http_stub_status_module \
 --with-http_sub_module \
 --with-http_v2_module \
 --with-mail=dynamic \
 --with-stream=dynamic \
 --with-http_geoip_module=dynamic \
 --with-http_image_filter_module=dynamic \
 --with-http_xslt_module=dynamic \
 --with-http_perl_module=dynamic \
 --with-perl_modules_path=/etc/nginx/perl \
 --add-dynamic-module=/root/build/nginx/naxsi/naxsi_src \
 --add-dynamic-module=/root/build/nginx/nginx-dav-ext \
 --add-dynamic-module=/root/build/nginx/fancyindex \
# && make CC=gcc-6 \
 && make \
 && make install \
 && apk del --no-cache .build \
 && rm -rf /root/build /root/.gnupg \
 && ln -s /usr/lib/nginx/modules /etc/nginx/modules

EXPOSE 80
EXPOSE 443

WORKDIR /etc/nginx

STOPSIGNAL SIGTERM

HEALTHCHECK --interval=1m --timeout=3s CMD curl --fail http://127.0.0.1:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]

