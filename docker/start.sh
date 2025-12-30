#!/bin/bash
# docker/start.sh

set -e  # Останавливаемся при ошибке

echo "====================================="
echo "🚀 Starting Laravel App on Render.com"
echo "====================================="

# Показываем переменные окружения (без паролей!)
echo "🌍 APP_ENV: ${APP_ENV}"
echo "🔗 APP_URL: ${APP_URL}"
echo "🗄️  DB_CONNECTION: ${DB_CONNECTION}"
echo "📡 DB_HOST: ${DB_HOST}"
echo "🚪 DB_PORT: ${DB_PORT}"
echo "📊 DB_DATABASE: ${DB_DATABASE}"
echo "👤 DB_USERNAME: ${DB_USERNAME}"
echo "🔐 DB_PASSWORD: ${DB_PASSWORD:+***set***}"

echo "⏳ Waiting for database to be ready..."

# Ждём доступности порта БД
for i in {1..30}; do
    if pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME" -d "$DB_DATABASE" -t 5 > /dev/null 2>&1; then
        echo "✅ Database is ready!"
        break
    fi
    echo "⏳ Database not ready, waiting... ($i/30)"
    sleep 5
done

if [ $i -eq 30 ]; then
    echo "❌ Database did not become ready in time."
    exit 1
fi

# Генерируем .env, если его нет
if [ ! -f ".env" ]; then
    echo "📝 .env not found, copying from .env.example"
    cp .env.example .env
fi

# Генерируем ключ, если не сгенерирован
if ! grep -q "APP_KEY=.*base64" .env; then
    echo "🔑 Generating APP_KEY..."
    php artisan key:generate --ansi
fi

# Кэшируем конфигурацию
echo "📦 Caching config and routes..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Миграции
echo "🔄 Running migrations..."
php artisan migrate --seed --force

# Запуск сервера
echo "🚀 Starting PHP built-in server on port $PORT"
exec php artisan serve --host=0.0.0.0 --port="$PORT"
