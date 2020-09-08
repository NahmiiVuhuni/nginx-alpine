FROM alpine:3.12.0

LABEL Maintainer="Hubok <docker-maint@hubok.net>" \
      Description="Nginx container on Alpine, compiled from source with nginx-dav-ext-module."

ENV VERSION_NGINX           1.19.2
ENV VERSION_NAXSI           0.56
ENV VERSION_DAV_EXT_MODULE  v3.0.0

#Update, upgrade, and add required packages
RUN apk -U upgrade \
 && apk add gzip pcre zlib perl openssl libxslt gd geoip \
 gnupg wget g++ pcre-dev zlib-dev make openssl-dev libxslt-dev gd-dev geoip-dev

#Copy all files from src into the root.
COPY src /

#Users, groups, permissions.
RUN addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

#Import gpg keys.
RUN gpg --import /root/build/0x520A9993A1C052F8.key \
 && gpg --import /root/build/0x251A28DE2685AED4.key \
 && printf "trusted-key 520A9993A1C052F8\ntrusted-key 251A28DE2685AED4" > /root/.gnupg/gpg.conf

#Download nginx and verify signer.
RUN wget https://nginx.org/download/nginx-${VERSION_NGINX}.tar.gz -O /root/build/nginx.tar.gz \
 && wget https://nginx.org/download/nginx-${VERSION_NGINX}.tar.gz.asc -O /root/build/nginx.tar.gz.asc \
 && gpg --import /root/build/0x520A9993A1C052F8.key \
 && gpg --verify /root/build/nginx.tar.gz.asc

#Download naxsi and verify signer.
RUN wget https://github.com/nbs-system/naxsi/archive/${VERSION_NAXSI}.tar.gz -O /root/build/naxsi.tar.gz \
 && wget https://github.com/nbs-system/naxsi/releases/download/${VERSION_NAXSI}/naxsi-${VERSION_NAXSI}.tar.gz.asc -O /root/build/naxsi.tar.gz.asc \
 && gpg --import /root/build/0x251A28DE2685AED4.key \
 && gpg --verify /root/build/naxsi.tar.gz.asc

#Download nginx-dav-ext-module.
RUN wget https://github.com/arut/nginx-dav-ext-module/archive/${VERSION_DAV_EXT_MODULE}.zip -O /root/build/nginx-dav-ext.zip

#Unarchive files.
RUN mkdir /root/build/nginx /root/build/nginx/naxsi /root/build/nginx/nginx-dav-ext \
 && tar -xvzf /root/build/nginx.tar.gz -C /root/build/nginx --strip-components=1 \
 && tar -xvzf /root/build/naxsi.tar.gz -C /root/build/nginx/naxsi --strip-components=1 \
 && unzip /root/build/nginx-dav-ext.zip -d /root/build/nginx/nginx-dav-ext -j

#Build nginx.
RUN mkdir /etc/nginx /etc/nginx/conf.d /etc/nginx/modules /etc/nginx/perl /var/log/nginx /var/pid
RUN /root/build/nginx/configure \
 --prefix=/usr/share/nginx \
 --conf-path=/etc/nginx/nginx.conf \
 --error-log-path=/var/log/nginx/error.log \
 --pid-path=/var/pid/nginx.pid \
 --user=nginx \
 --group=nginx \
 --http-log-path=/var/log/nginx/access.log \
 --with-select_module \
 --with-poll_module \
 --with-threads \
 --with-http_ssl_module \
 --with-http_v2_module \
 --with-http_realip_module \
 --with-http_addition_module \
 --with-http_xslt_module=dynamic \
 --with-http_image_filter_module=dynamic \
 --with-http_geoip_module=dynamic \
 --with-http_sub_module \
 --with-http_dav_module \
 --with-http_flv_module \
 --with-http_mp4_module \
 --with-http_gunzip_module \
 --with-http_gzip_static_module \
 --with-http_auth_request_module \
 --with-http_random_index_module \
 --with-http_secure_link_module \
 --with-http_degradation_module \
 --with-http_slice_module \
 --with-http_stub_status_module \
 --with-http_perl_module=dynamic \
 --with-perl_modules_path=/etc/nginx/perl
RUN make

#Cleanup
#RUN apk del gnupg wget g++ pcre-dev zlib-dev make openssl-dev libxslt-dev gd-dev geoip-dev
#RUN rm -rf /root/biuild /root/.gnupg

EXPOSE 80
EXPOSE 443

#WORKDIR /var/www/html
WORKDIR /root/build/nginx

STOPSIGNAL SIGTERM

#HEALTHCHECK --interval=3s --timeout=1s --start-period=15s --retries=3 CMD 

#CMD ["nginx"]
CMD ["/bin/sh"]

