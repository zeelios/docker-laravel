FROM php:fpm

# Set working directory
WORKDIR /var/www/adult

# Copy composer.lock and composer.json
COPY . /var/www/adult/

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libonig-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www && useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents and permissions to the container's workspace.
COPY . /var/www/adult
COPY --chown=www-data:www-data . /var/www/adult

# Change current user to www-data.
USER www-data

# Expose port 9000 and start php-fpm server.
EXPOSE 9000

CMD ["php-fpm"]
