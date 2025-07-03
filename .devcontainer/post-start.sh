#!/bin/bash

echo "🔄 Post-start setup..."

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 5

# Check if database is ready
echo "🗄️ Checking database connection..."
until pg_isready -h postgres -p 5432 -U taskflow; do
    echo "Waiting for PostgreSQL..."
    sleep 2
done

# Check if Redis is ready
echo "📦 Checking Redis connection..."
until redis-cli -h redis ping; do
    echo "Waiting for Redis..."
    sleep 2
done

# Run any pending migrations
echo "🔄 Running database migrations..."
cd backend
if [ -f prisma/schema.prisma ]; then
    npx prisma db push --skip-generate 2>/dev/null || echo "No migrations to run"
fi
cd ..

echo "✅ Post-start setup complete!"
echo ""
echo "🌟 Development environment is ready!"
echo "📊 Access pgAdmin at: http://localhost:8080"
echo "🔍 Run Prisma Studio: npx prisma studio"