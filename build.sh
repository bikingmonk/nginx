#!/bin/bash

yum update -y
yum install gcc-c++ make perl -y

useradd -r nginx

cd /tmp

curl https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz -o pcre-8.43.tar.gz
tar -xvf pcre-8.43.tar.gz
rm -rf pcre-8.43.tar.gz

curl https://zlib.net/zlib-1.2.11.tar.gz -o zlib-1.2.11.tar.gz
tar -xvf zlib-1.2.11.tar.gz
rm -rf zlib-1.2.11.tar.gz

curl https://www.openssl.org/source/openssl-1.1.1b.tar.gz -o openssl-1.1.1b.tar.gz
tar -xvf openssl-1.1.1b.tar.gz
rm -rf openssl-1.1.1b.tar.gz

curl https://nginx.org/download/nginx-1.16.0.tar.gz -o nginx-1.16.0.tar.gz
tar -xvf nginx-1.16.0.tar.gz
rm -rf nginx-1.16.0.tar.gz

cd nginx-1.16.0

./configure \
--user=nginx \
--group=nginx \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--with-pcre=../pcre-8.43/ \
--with-zlib=../zlib-1.2.11/ \
--with-openssl=../openssl-1.1.1b/ \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_auth_request_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
--without-http_fastcgi_module

make

make install

yum remove gcc-c++ make perl -y

cd /opt

rm -rf /tmp/pcre-8.43
rm -rf /tmp/zlib-1.2.11
rm -rf /tmp/openssl-1.1.1b
rm -rf /tmp/nginx-1.16.0