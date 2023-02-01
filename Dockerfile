FROM php:7.4.16-cli-alpine

RUN apk update \
&& apk add --no-cache --virtual .build-dependencies zip zlib-dev libzip-dev libpng-dev \
&& php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
&& apk del .build-dependencies \
&& docker-php-ext-install sockets bcmath \
&& apk add --no-cache git \
&& apk add --no-cache zip libzip-dev \
&& docker-php-ext-configure zip \
&& docker-php-ext-install zip \
&& apk add --no-cache libpng libpng-dev \
&& docker-php-ext-install gd \
&& apk del libpng-dev

COPY ./custom.ini /usr/local/etc/php/conf.d/

WORKDIR /app

RUN composer self-update 2.0.14

ENTRYPOINT ["composer"]