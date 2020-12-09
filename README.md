# Quick reference
- **Maintained by**: [Hubok](https://github.com/Hubok) and [the Nginx Developers](https://trac.nginx.org/nginx/browser)
- **Where to get help**: [the Docker Community Forums](https://forums.docker.com/), [the Docker Community Slack](https://dockr.ly/slack), or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

# Supported tags and respective `Dockerfile` links
- [`1.19.5`, `mainline`, `latest`](https://github.com/Hubok/nginx-alpine/blob/1.19.5/Dockerfile)
- [`1.19.4`](https://github.com/Hubok/nginx-alpine/blob/1.19.4/Dockerfile)
- [`1.19.3`](https://github.com/Hubok/nginx-alpine/blob/1.19.3/Dockerfile)
- [`1.19.2`](https://github.com/Hubok/nginx-alpine/blob/1.19.2/Dockerfile)

# Quick reference (cont.)
- **Where to file issues**: https://github.com/Hubok/nginx-alpine/issues
- **Supported architectures**: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64)) `amd64`

# What is this image?
This image builds Nginx **from source**, compiling all first-party modules except Google Performance tools, and with [Naxsi](https://github.com/nbs-system/naxsi) and [nginx-dav-ext-module](https://github.com/arut/nginx-dav-ext-module). This image pulls from Alpine directly, **not** fork from Nginx, so the Nginx Docker Maintainers should not be contacted with issues.

The following configure arguments were specified when compiling Nginx:
`--prefix=/usr/lib/nginx --sbin-path=/sbin/nginx --pid-path=/var/pid/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/dev/stdout --error-log-path=/dev/stderr --pid-path=/var/pid/nginx.pid --user=nginx --group=nginx --with-file-aio --with-pcre-jit --with-threads --with-poll_module --with-select_module --with-stream_ssl_module --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-mail_ssl_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail=dynamic --with-stream=dynamic --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_xslt_module=dynamic --with-http_perl_module=dynamic --with-perl_modules_path=/etc/nginx/perl --add-dynamic-module=/root/build/nginx/naxsi/naxsi_src --add-dynamic-module=/root/build/nginx/nginx-dav-ext`

# How to use this image
- Follow instructions from [the Nginx Docker page](https://hub.docker.com/repository/docker/hubok/nginx-alpine/general)
- The default nginx.conf is included, and may not work with your setup.
- Dynamic modules are not loaded by default, and may be found in: `/usr/lib/nginx/modules`
- The nginx PID file may be found at: `/var/pid/nginx.pid`

# License
View [license information](https://github.com/Hubok/nginx-alpine/blob/master/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as sh, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
