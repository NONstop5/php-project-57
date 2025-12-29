include ./compose.mk

start:
	php artisan serve --host=0.0.0.0

start-frontend:
	npm run dev

install:
	composer install
	npm ci
	npm run build

env-prepare:
	php -r "file_exists('.env') || copy('.env.example', '.env');"

setup:
	make env-prepare
	php artisan key:gen --ansi
	php artisan migrate
	php artisan db:seed
	make ide-helper

watch:
	npm run watch

migrate:
	php artisan migrate

tinker:
	php artisan tinker

log:
	tail -f storage/logs/laravel.log

test:
	php artisan test

test-coverage:
	XDEBUG_MODE=coverage php artisan test --coverage-clover build/logs/clover.xml

validate:
	composer validate

lint:
	composer phpcs
	vendor/bin/phpstan analyse

lint-fix:
	composer phpcbf

ide-helper:
	php artisan ide-helper:eloquent
	php artisan ide-helper:gen
	php artisan ide-helper:meta
	php artisan ide-helper:mod -n
