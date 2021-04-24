# Aplikasi Reservasi Aset

Backend API untuk Aplikasi Reservasi Aset di Jabar Digital Service.

<a href="https://codeclimate.com/github/ayocodingit/boilerplate-laravel-8/maintainability"><img src="https://api.codeclimate.com/v1/badges/021fe7fdf0dc5a71adbc/maintainability" /></a>
<a href="https://codeclimate.com/github/ayocodingit/boilerplate-laravel-8/test_coverage"><img src="https://api.codeclimate.com/v1/badges/021fe7fdf0dc5a71adbc/test_coverage" /></a>

## Petunjuk development
1. Ikuti Development Guides https://github.com/jabardigitalservice/development-guides
2. Clean Code, ikuti standard style FIG PSR-12 dengan menggunakan PHP Code Sniffer.
3. Clean Architecture, ikuti Laravel Best practices https://github.com/alexeymezenin/laravel-best-practices
4. Maksimalkan fitur-fitur built-in Laravel. Minimum dependencies.
5. Thin Controller. Gunakan Single Action Controller.
6. Tulis script Unit dan Feature Test.
7. Horizontal scalable, perhatikan 12-factor https://12factor.net
8. Log, Log, Log!

## Arsitektur Stack
1. PHP 7.3|8.0, Laravel ^8.x
2. MySQL 8, SQLite
3. Keycloak Identity & Access Management
4. JWT
5. Laravel Outh2

## Bagaimana cara memulai development?
Clone Repository terlebih dahulu:
```
$ git clone https://github.com/ayocodingit/boilerplate-laravel-8
```

Copy file config dan sesuaikan konfigurasinya
```
$ copy .env.example .env
```

Install dependencies menggunakan Composer"
```
$ composer install
```

Jalankan Artisan untuk migrasi dan seed database:
```
$ php artisan migrate:fresh --seed
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
