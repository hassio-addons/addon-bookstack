ARG BUILD_FROM=hassioaddons/base:7.1.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        mariadb-client=10.4.12-r0 \
        nginx=1.16.1-r6 \
        php7-curl=7.3.17-r0 \
        php7-dom=7.3.17-r0 \
        php7-fileinfo=7.3.17-r0 \
        php7-fpm=7.3.17-r0 \
        php7-gd=7.3.17-r0 \
        php7-json=7.3.17-r0 \
        php7-mbstring=7.3.17-r0 \
        php7-mysqlnd=7.3.17-r0 \
        php7-openssl=7.3.17-r0 \
        php7-pdo_mysql=7.3.17-r0 \
        php7-session=7.3.17-r0 \
        php7-simplexml=7.3.17-r0 \
        php7-tidy=7.3.17-r0 \
        php7-tokenizer=7.3.17-r0 \
        php7-xml=7.3.17-r0 \
        php7=7.3.17-r0 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        composer=1.9.1-r0 \
    \
    && curl -J -L -o /tmp/bookstack.tar.gz \
        https://github.com/BookStackApp/BookStack/archive/v0.29.2.tar.gz \
    &&  mkdir -p /var/www/bookstack \
    && tar zxvf /tmp/bookstack.tar.gz -C \
        /var/www/bookstack --strip-components=1 \
    && cd /var/www/bookstack \
    \
    && composer install --no-dev \
    && apk del --no-cache --purge .build-dependencies \
    \
    && find /var/www/bookstack -type f -name "*.md" -depth -exec rm -f {} \; \
    && rm -f -r \
         /tmp/* \
         /var/www/bookstack/tests \
         /var/www/bookstack/dev

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Bookstack" \
    io.hass.description="Bookstack: Simple & Free Wiki Software" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Paul Sinclair <hello@addons.community>" \
    org.label-schema.description="Bookstack: Simple & Free Wiki Software" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Bookstack" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-bookstack/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-bookstack" \
    org.label-schema.vendor="Home Assistant Community Addons"
