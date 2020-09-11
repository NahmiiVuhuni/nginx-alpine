# nginx-alpine

This is an Nginx container running on Alpine built from source, with all first-party modules except Google Performance tools, and with naxsi and nginx-dav-ext-module.<br/><br/>
`nginx -V`<br/>
`nginx version: nginx/1.19.2`<br/>
`built by gcc 9.3.0 (Alpine 9.3.0)`<br/>
`built with OpenSSL 1.1.1g  21 Apr 2020`<br/>
`TLS SNI support enabled`<br/>
`configure arguments: --prefix=/usr/lib/nginx --sbin-path=/sbin/nginx --pid-path=/var/pid/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/dev/stdout --error-log-path=/dev/stderr --pid-path=/var/pid/nginx.pid --user=nginx --group=nginx --with-file-aio --with-pcre-jit --with-threads --with-poll_module --with-select_module --with-stream_ssl_module --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-mail_ssl_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail=dynamic --with-stream=dynamic --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_xslt_module=dynamic --with-http_perl_module=dynamic --with-perl_modules_path=/etc/nginx/perl --add-dynamic-module=/root/build/nginx/naxsi/naxsi_src --add-dynamic-module=/root/build/nginx/nginx-dav-ext`
