# Boilerplate Laravel 8

A Laravel starter project template.

[![Build Status](https://travis-ci.com/ayocodingit/boilerplate-laravel-8.svg?branch=master)](https://travis-ci.com/ayocodingit/boilerplate-laravel-8)
<a href="https://codeclimate.com/github/ayocodingit/boilerplate-laravel-8/maintainability"><img src="https://api.codeclimate.com/v1/badges/021fe7fdf0dc5a71adbc/maintainability" /></a>
<a href="https://codeclimate.com/github/ayocodingit/boilerplate-laravel-8/test_coverage"><img src="https://api.codeclimate.com/v1/badges/021fe7fdf0dc5a71adbc/test_coverage" /></a>

## Petunjuk development
1. Clean Code, ikuti standard style FIG PSR-12 dengan menggunakan PHP Code Sniffer.
2. Clean Architecture, ikuti Laravel Best practices https://github.com/alexeymezenin/laravel-best-practices
3. Maksimalkan fitur-fitur built-in Laravel. Minimum dependencies.
4. Thin Controller. Gunakan Single Action Controller.
5. Tulis script Unit dan Feature Test.
6. Horizontal scalable, perhatikan 12-factor https://12factor.net

## Arsitektur Stack
1. PHP 8.0, Laravel 8.x
2. MySQL, SQLite
3. Keycloak Identity & Access Management
4. Laravel spectrum

## Bagaimana cara memulai development?
Clone Repository terlebih dahulu:
```
$ git clone https://github.com/ayocodingit/boilerplate-laravel-8
```

Copy file config dan sesuaikan konfigurasinya
```
$ copy .env.example .env
```

Generate APP_KEY to .env
```
$ php artisan key:generate
```

Install dependencies menggunakan Composer
```
$ composer install
```
Jalan Artisan Local Development Server:
```
$ php artisan serve
```

### Run Code Style check
```
$ ./vendor/bin/phpcs
```

### Run Unit & Feature Test
```
$ ./vendor/bin/phpunit
```

## Bagaimana cara memulai Deploy?

terdapat 2 cara deploy pada server yaitu Base Dockerfile atau Base Docker Compose

## Pre-Requirement installed
1. git
2. docker
3. docker-compose
4. port 8080
5. Set ENV Docker_APP untuk menjalankan sebagai Aplikasi (app), Queue (queue) atau Scheduler (scheduler)

### Base Dockerfile
1. Clone Repository terlebih dahulu:
```
$ git clone https://github.com/ayocodingit/boilerplate-laravel-8
```
2. jalankan perintah docker build -t app:latest .
```
$ docker build -t app:latest .
```
3. jalankan perintah docker run -p 8080:8080 app:latest
```
$ docker run -p 8080:8080 app:latest
```

### Base Docker-compose
1. Clone Repository terlebih dahulu:
```
$ git clone https://github.com/ayocodingit/boilerplate-laravel-8
```
2. jalankan perintah docker-compose up -d
```
$ docker-compose up -d
```
```
