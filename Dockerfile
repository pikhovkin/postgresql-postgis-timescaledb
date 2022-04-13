# https://github.com/docker-library/postgres/blob/master/13/alpine/Dockerfile
FROM postgres:13.6-alpine

MAINTAINER Sergei Pikhovkin

ENV ALPINE_VERSION v3.15

# https://postgis.net/docs/manual-3.2/postgis_installation.html
ENV POSTGIS_VERSION 3.2.1
ENV POSTGIS_SHA256 1e9cc4c4f390e4c3be4f5c125a72f39dfa847412332952429952cbd731ac9ba3
RUN set -ex \
    \
    && apk add --no-cache --virtual .fetch-deps \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/community \
        build-base \
        ca-certificates \
        openssl \
        git \
        tar \
    && apk add --no-cache --virtual .build-deps \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/community \
        make \
        automake \
        autoconf \
        libtool \
        file \
        gcc \
        g++ \
        perl \
        clang-dev \
        llvm-dev \
        libxml2-dev \
        \
        json-c-dev \
        geos-dev \
        gdal-dev \
        proj-dev \
        protobuf-c-dev \
        postgresql-dev \
    && apk add --no-cache --virtual .postgis-rundeps \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/community \
        json-c \
        geos \
        gdal \
        proj \
        protobuf-c \
    \
    && wget -O postgis.tar.gz "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
    && echo "$POSTGIS_SHA256 *postgis.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/postgis \
    && tar --extract --file postgis.tar.gz --directory /usr/src/postgis --strip-components 1 \
    && rm postgis.tar.gz \
    \
    && cd /usr/src/postgis \
    && ./autogen.sh \
    && ./configure \
    && make -s \
    && make -s install \
    && cd / \
    && rm -rf /usr/src/postgis \
    && apk del .fetch-deps .build-deps

# https://docs.timescale.com/timescaledb/latest/how-to-guides/install-timescaledb/self-hosted/ubuntu/installation-source
ENV TIMESCALEDB_VERSION 2.6.1
ENV TIMESCALEDB_SHA256 226af207105cc9e2d1744b303e475204a947047103f0e5697de4e8949e4dde75
RUN set -ex \
    && apk add --no-cache --virtual .fetch-deps \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/community \
        build-base \
        ca-certificates \
        git \
        tar \
    && apk add --no-cache --virtual .build-deps \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/community \
        make \
        cmake \
        gcc \
        clang \
        clang-dev \
        llvm-dev \
        dpkg \
        dpkg-dev \
        util-linux-dev \
        libc-dev \
        coreutils \
        krb5-dev \
    && apk add --no-cache --virtual .timescaledb-rundeps \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/$ALPINE_VERSION/community \
        openssl \
        openssl-dev \
    \
    && wget -O timescaledb.tar.gz "https://github.com/timescale/timescaledb/archive/$TIMESCALEDB_VERSION.tar.gz" \
    && echo "$TIMESCALEDB_SHA256 *timescaledb.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/timescaledb \
    && tar --extract --file timescaledb.tar.gz --directory /usr/src/timescaledb --strip-components 1 \
    && rm timescaledb.tar.gz \
    \
    && cd /usr/src/timescaledb \
    && ./bootstrap -DPROJECT_INSTALL_METHOD="docker" -DREGRESS_CHECKS=OFF \
    && cd ./build && make install \
    \
    && cd / \
    && rm -rf /usr/src/timescaledb \
    && apk del .fetch-deps .build-deps \
    && sed -r -i "s/[#]*\s*(shared_preload_libraries)\s*=\s*'(.*)'/\1 = 'timescaledb,\2'/;s/,'/'/" /usr/local/share/postgresql/postgresql.conf.sample

COPY ./init-postgis.sh /docker-entrypoint-initdb.d/1.postgis.sh
COPY ./init-timescaledb.sh /docker-entrypoint-initdb.d/2.timescaledb.sh
COPY ./init-postgres.sh /docker-entrypoint-initdb.d/3.postgres.sh
