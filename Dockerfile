FROM ubuntu:noble
RUN apt update
RUN apt install -y build-essential git autoconf libtool pkg-config autotools-dev libpsl-dev libidn2-dev libgsasl-dev
# RUN dpkg -r --force-depends openssl

ARG OPENSSL_VERSION=3.5.0
RUN cd / && \
 git clone --quiet --depth=1 -b openssl-$OPENSSL_VERSION https://github.com/openssl/openssl && \
 cd openssl && \
 ./config --prefix=/opt/openssl --libdir=lib && \
 make && \
 make install

ARG NGHTTP3_VERSION=v1.9.0
RUN cd / && \
 git clone -b $NGHTTP3_VERSION https://github.com/ngtcp2/nghttp3 && \
 cd nghttp3 && \
 git submodule update --init && \
 autoreconf -fi && \
 ./configure --prefix=/opt/nghttp --enable-lib-only && \
 make && \
 make install

ARG NGTCP2_VERSION=v1.12.0
RUN cd / && \
 git clone -b $NGTCP2_VERSION https://github.com/ngtcp2/ngtcp2 && \
 cd ngtcp2 && \
 git submodule update --init && \
 autoreconf -fi && \
 ./configure PKG_CONFIG_PATH=/opt/openssl/lib/pkgconfig:/opt/nghttp/lib/pkgconfig LDFLAGS="-Wl,-rpath,/opt/openssl/lib" --prefix=/opt/ngtcp --enable-lib-only --with-openssl && \
 make && \
 make install

ARG CURL_VERSION=master
RUN cd / && \
 git clone -b $CURL_VERSION https://github.com/curl/curl && \
 cd curl && \
 autoreconf -fi && \
 LDFLAGS="-Wl,-rpath,/opt/openssl/lib" ./configure --with-openssl=/opt/openssl --with-nghttp3=/opt/nghttp --with-ngtcp2=/opt/ngtcp && \
 make && \
 make install

ENV LD_LIBRARY_PATH=/usr/local/lib