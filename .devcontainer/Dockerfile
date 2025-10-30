FROM php:8.2-apache

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# Enable .htaccess files & mod_rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf
RUN a2enmod rewrite

#Most of this comes directly from the WordPress docker image
#We don't inherit from it becase it has a VOLUME that causes issues
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends ghostscript git less ssh-client mariadb-client; \
	rm -rf /var/lib/apt/lists/*

# install Node.js 20 and enable corepack/pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - ; \
	apt-get install -y nodejs; \
	rm -rf /var/lib/apt/lists/*; \
	corepack enable

# install the PHP extensions, including Xdebug 3
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libmagickwand-dev \
		libpng-dev \
		libzip-dev \
	; \
	docker-php-ext-configure gd --with-freetype --with-jpeg; \
	docker-php-ext-install -j "$(nproc)" \
		bcmath \
		exif \
		gd \
		mysqli \
		opcache \
		zip \
	; \
	pecl install imagick; \
	pecl install xdebug; \
	docker-php-ext-enable imagick xdebug;\
	rm -rf /var/lib/apt/lists/*

# Xdebug 3 settings
RUN echo "[Xdebug]\n\
xdebug.mode=debug,develop\n\
xdebug.start_with_request=yes\n\
xdebug.client_host=host.docker.internal\n\
xdebug.client_port=9003\n\
xdebug.discover_client_host=1" > $PHP_INI_DIR/conf.d/xdebug.ini

#WP recommended PHP settings
RUN { \
	echo 'opcache.memory_consumption=128'; \
	echo 'opcache.interned_strings_buffer=8'; \
	echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=2'; \
	echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Mailhog sendmail setup
RUN curl -fsSL -o /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x /usr/local/bin/mhsendmail \
    && printf "[mail function]\nsendmail_path = \"/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025\"\n" > /usr/local/etc/php/conf.d/mailhog.ini

# Increase PHP memory (CLI/web)
RUN echo 'memory_limit=512M' > /usr/local/etc/php/conf.d/zz-memory.ini

#install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

#install Composer
WORKDIR /tmp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
		&& php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer

#add vscode user

RUN useradd -ms /bin/bash vscode \
		&& usermod -aG www-data vscode

# Install sudo and supervisor and allow vscode user to run commands as www-data
RUN apt-get update \
    && apt-get install -y sudo supervisor \
    && echo "vscode ALL=(www-data) NOPASSWD: ALL" >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/supervisor

# Ensure WP-CLI uses a writable home/cache and more memory
ENV HOME=/var/www/html \
    WP_CLI_CACHE_DIR=/var/www/html/.wp-cli/cache \
    WP_CLI_PHP_ARGS="-d memory_limit=512M"

WORKDIR /var/www/html
USER www-data

# Prepare WP-CLI cache dir
RUN mkdir -p $WP_CLI_CACHE_DIR

#Download WP
RUN wp core download

#add dirs for plugin and theme dev
RUN mkdir -p /var/www/html/wp-content/plugins/my-plugin; \
	mkdir -p /var/www/html/wp-content/themes/my-theme;

USER root
RUN chown -R www-data:www-data /var/www/html/
RUN chmod g+w -R /var/www/html/
RUN find /var/www/html/ -type d -exec chmod g+s {} \;

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]