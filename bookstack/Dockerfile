ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:9.1.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        mariadb-client=10.5.8-r0\
        nginx=1.18.0-r13 \
        php7-curl=7.4.15-r0 \
        php7-dom=7.4.15-r0 \
        php7-fileinfo=7.4.15-r0 \
        php7-fpm=7.4.15-r0 \
        php7-gd=7.4.15-r0 \
        php7-json=7.4.15-r0 \
        php7-mbstring=7.4.15-r0 \
        php7-mysqlnd=7.4.15-r0 \
        php7-openssl=7.4.15-r0 \
        php7-pdo_mysql=7.4.15-r0 \
        php7-session=7.4.15-r0 \
        php7-simplexml=7.4.15-r0 \
        php7-tidy=7.4.15-r0 \
        php7-tokenizer=7.4.15-r0 \
        php7-xml=7.4.15-r0 \
        php7=7.4.15-r0 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        composer=2.0.9-r0 \
    \
    && curl -J -L -o /tmp/bookstack.tar.gz \
        https://github.com/BookStackApp/BookStack/archive/v0.31.5.tar.gz \
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
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Paul Sinclair <hello@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Paul Sinclair <hello@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
